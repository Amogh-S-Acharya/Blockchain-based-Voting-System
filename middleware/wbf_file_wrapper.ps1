# WBF/USB Vendor CLI File Wrapper
# Usage examples:
#   powershell -ExecutionPolicy Bypass -File .\middleware\wbf_file_wrapper.ps1 --capture --json --cmd "C:\Path\To\VendorCapture.exe" --args "--once --timeout 15000" --out "C:\Users\Public\fp_template.bin"
#   (the middleware will call this with --capture --json; you configure --cmd/--args/--out via FP_CLI_ARGS)

param(
  [switch]$capture,
  [switch]$json,
  [string]$cmd = "",
  [string]$args = "",
  [string]$out = ""
)

function Write-Json($obj) {
  $obj | ConvertTo-Json -Compress | Write-Output
}

try {
  if (-not $capture -or -not $json) {
    Write-Json @{ ok = $false; error = "Missing --capture --json" }
    exit 2
  }
  if ([string]::IsNullOrWhiteSpace($cmd)) {
    Write-Json @{ ok = $false; error = "Missing --cmd <vendor_exe>" }
    exit 2
  }
  if ([string]::IsNullOrWhiteSpace($out)) {
    # default output to temp
    $out = Join-Path $env:TEMP ("fp_template_" + [Guid]::NewGuid().ToString() + ".bin")
  } else {
    $outDir = Split-Path -Parent $out
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
  }

  if (Test-Path $out) { Remove-Item -Force $out -ErrorAction SilentlyContinue }

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $cmd
  $psi.Arguments = $args
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $proc = [System.Diagnostics.Process]::Start($psi)

  # Wait for process to exit (max 30s) and for file to appear (polling)
  if (-not $proc.WaitForExit(30000)) {
    try { $proc.Kill() } catch {}
    Write-Json @{ ok = $false; error = "Vendor capture timeout" }
    exit 1
  }

  # If vendor writes to stdout with path, try to parse last non-empty line as path when --out not supplied
  if (-not (Test-Path $out)) {
    $stdout = $proc.StandardOutput.ReadToEnd()
    $stderr = $proc.StandardError.ReadToEnd()
    $candidate = ($stdout.Split("`n") | Where-Object { $_ -and -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Last 1).Trim()
    if ($candidate -and (Test-Path $candidate)) { $out = $candidate }
  }

  $deadline = (Get-Date).AddSeconds(5)
  while (-not (Test-Path $out)) {
    Start-Sleep -Milliseconds 100
    if ((Get-Date) -gt $deadline) { break }
  }

  if (-not (Test-Path $out)) {
    Write-Json @{ ok = $false; error = "No template file produced" }
    exit 1
  }

  $bytes = [System.IO.File]::ReadAllBytes($out)
  if (-not $bytes -or $bytes.Length -eq 0) {
    Write-Json @{ ok = $false; error = "Empty template file" }
    exit 1
  }

  $b64 = [System.Convert]::ToBase64String($bytes)
  Write-Json @{ ok = $true; templateBase64 = $b64 }
  exit 0
} catch {
  Write-Json @{ ok = $false; error = $_.Exception.Message }
  exit 1
}


