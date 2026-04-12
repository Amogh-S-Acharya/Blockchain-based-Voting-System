# Fix Weights Files

## Issues Found

1. **Wrong filename**: `face_landmark_68_tiny_model-shard1` should be `face_landmark_68_model-shard1`
2. **Missing file**: `face_recognition_model-shard2` is required

## Quick Fix

### Step 1: Rename the landmark model file

**Rename:**
- `face_landmark_68_tiny_model-shard1` 
- **To:** `face_landmark_68_model-shard1`

### Step 2: Download missing shard file

Download `face_recognition_model-shard2` from:
https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/face_recognition_model-shard2

Or use this command:
```bash
cd weights
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/face_recognition_model-shard2
```

## Final File List

Your `weights` folder should have these 7 files:
1. ✅ `tiny_face_detector_model-weights_manifest.json`
2. ✅ `tiny_face_detector_model-shard1`
3. ✅ `face_landmark_68_model-weights_manifest.json`
4. ✅ `face_landmark_68_model-shard1` (renamed from tiny version)
5. ✅ `face_recognition_model-weights_manifest.json`
6. ✅ `face_recognition_model-shard1`
7. ⚠️ `face_recognition_model-shard2` (needs to be downloaded)

## After Fix

1. Restart your server
2. Refresh the browser
3. Models should load successfully!

