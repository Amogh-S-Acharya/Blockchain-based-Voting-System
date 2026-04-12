# Host Face-API.js Models Locally

**⚠️ IMPORTANT: This is required due to CORS issues with CDN!**

Your server is already configured to serve the `weights` folder. You just need to download the model files.

## Step 1: Download Model Files

### Option A: Direct Download (Recommended)

1. Go to: https://github.com/justadudewhohacks/face-api.js/tree/master/weights
2. Click on each file and download them:
   - `tiny_face_detector_model-weights_manifest.json`
   - `tiny_face_detector_model-shard1`
   - `face_landmark_68_model-weights_manifest.json`
   - `face_landmark_68_model-shard1`
   - `face_recognition_model-weights_manifest.json`
   - `face_recognition_model-shard1`

### Option B: Clone Entire Weights Folder (Easier)

```bash
# In your project root directory
mkdir weights
cd weights
curl -L https://github.com/justadudewhohacks/face-api.js/archive/master.zip -o face-api.zip
# Extract only the weights folder contents
# Or use git sparse checkout
```

### Option C: Use Git to Download Just Weights

```bash
# Create weights folder
mkdir weights
cd weights

# Download files using curl/wget
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/tiny_face_detector_model-weights_manifest.json
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/tiny_face_detector_model-shard1
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/face_landmark_68_model-weights_manifest.json
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/face_landmark_68_model-shard1
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/face_recognition_model-weights_manifest.json
curl -O https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights/face_recognition_model-shard1
```

## Step 2: Create Weights Folder Structure

Your project should look like this:
```
Mini_project/
├── weights/                          ← Create this folder
│   ├── tiny_face_detector_model-weights_manifest.json
│   ├── tiny_face_detector_model-shard1
│   ├── face_landmark_68_model-weights_manifest.json
│   ├── face_landmark_68_model-shard1
│   ├── face_recognition_model-weights_manifest.json
│   └── face_recognition_model-shard1
├── html/
├── backend/
└── server.js
```

## Step 3: Verify Server Configuration

Your `server.js` already has this line (line 14):
```javascript
app.use(express.static('weights'));
```

✅ **This is already configured!** No changes needed.

## Step 4: Code is Already Updated

Both `register.html` and `dashboard.html` are already set to use `/weights`:
```javascript
await faceapi.nets.tinyFaceDetector.loadFromUri('/weights')
await faceapi.nets.faceLandmark68Net.loadFromUri('/weights')
await faceapi.nets.faceRecognitionNet.loadFromUri('/weights')
```

## Quick Test

1. After downloading files, restart your server
2. Open browser console
3. Navigate to: `http://localhost:3000/weights/tiny_face_detector_model-weights_manifest.json`
4. You should see the JSON file content (not 404)

## Troubleshooting

### Still Getting 404?
- Make sure `weights` folder is in the project root (same level as `server.js`)
- Check file names match exactly (case-sensitive)
- Restart your server after adding files

### CORS Errors?
- Local hosting eliminates CORS issues
- Make sure you're using `/weights` not `https://...`

### Models Not Loading?
- Check browser console for specific file errors
- Verify all 6 files are in the weights folder
- Check server logs for any errors

