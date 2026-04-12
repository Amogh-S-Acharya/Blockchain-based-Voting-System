# Face Verification Setup Guide

## Overview
This voting system uses face-api.js for face recognition to verify voter identity during registration and voting.

## Supabase Database Requirements

### Column: `face_descriptor`

**Column Specifications:**
- **Name:** `face_descriptor`
- **Type:** `JSONB` (recommended) or `TEXT`
- **Nullable:** `true` (optional, for backward compatibility)
- **Default:** `null`

**Data Format:**
- The face descriptor is stored as a JSON array of 128 floating-point numbers
- Example: `[0.123, -0.456, 0.789, ...]` (128 numbers)
- This represents a 128-dimensional vector that uniquely identifies a face

**Why JSONB?**
- JSONB allows efficient storage and querying of JSON data in PostgreSQL
- Supports indexing for faster searches
- Automatic validation of JSON format
- Better performance than TEXT for JSON operations

**Alternative: TEXT**
- If JSONB is not available, TEXT can be used
- Data will be stored as a JSON string: `"[0.123, -0.456, ...]"`
- Requires JSON parsing when reading

## SQL to Add Column

### Option 1: JSONB (Recommended)
```sql
ALTER TABLE voters 
ADD COLUMN face_descriptor JSONB;

-- Optional: Add index for better query performance
CREATE INDEX idx_voters_face_descriptor ON voters USING GIN (face_descriptor);
```

### Option 2: TEXT (Alternative)
```sql
ALTER TABLE voters 
ADD COLUMN face_descriptor TEXT;

-- Add constraint to ensure valid JSON format (optional)
ALTER TABLE voters 
ADD CONSTRAINT face_descriptor_is_json 
CHECK (face_descriptor IS NULL OR face_descriptor::jsonb IS NOT NULL);
```

## How It Works

### Registration Flow (`register.html`)
1. User fills out registration form
2. Camera captures face using face-api.js
3. Face descriptor (128-dim vector) is extracted
4. Descriptor is sent to backend and stored in `face_descriptor` column
5. Registration completes

### Voting Flow (`dashboard.html`)
1. User clicks "Vote" button
2. System fetches stored face descriptor from Supabase
3. Face verification modal opens
4. Camera captures current face
5. Face descriptors are compared using Euclidean distance
6. If distance < 0.6 (threshold), verification passes
7. User proceeds with voting

## Face Recognition Details

### Models Used
- **TinyFaceDetector**: Fast face detection
- **FaceLandmark68Net**: 68 facial landmark points
- **FaceRecognitionNet**: 128-dimensional face descriptor

### Verification Threshold
- **Distance Threshold:** 0.6
- **Lower values** = Stricter (fewer false positives, more false negatives)
- **Higher values** = More lenient (more false positives, fewer false negatives)
- Adjust threshold in `dashboard.html` `verifyFace()` function if needed

### Face Descriptor
- 128 floating-point numbers
- Each value typically between -1 and 1
- Generated using deep learning model
- Unique to each face (with high probability)

## Testing

### Test Registration
1. Open `register.html`
2. Fill form and allow camera access
3. Position face in frame
4. Click "Capture Face"
5. Complete registration
6. Verify `face_descriptor` column has data in Supabase

### Test Voting
1. Login to dashboard
2. Click "Vote" on any candidate
3. Face verification modal should open
4. Position face in frame
5. Click "Verify Face"
6. Should verify successfully if same person

## Troubleshooting

### Camera Access Denied
- Ensure HTTPS (required for camera access)
- Check browser permissions
- User must explicitly allow camera access

### Face Not Detected
- Ensure good lighting
- Face should be clearly visible
- Remove glasses/obstructions if needed
- Maintain appropriate distance from camera

### Verification Fails
- Check if face descriptor exists in database
- Verify lighting conditions match registration
- Try adjusting threshold (0.5-0.7 range)
- Ensure same person is verifying

### Models Not Loading
- **CDN Issue**: If using unpkg CDN and models fail to load, try hosting models locally
- **Local Hosting**: Download weights from [face-api.js GitHub](https://github.com/justadudewhohacks/face-api.js/tree/master/weights) and place in `/weights` folder
- Check internet connection if using CDN
- Verify face-api.js library is loaded correctly
- Alternative CDN: Use `https://unpkg.com/face-api.js@0.22.2/weights` (unpkg) instead of jsdelivr

## Security Considerations

1. **Face descriptors are stored securely** in Supabase
2. **No actual images** are stored, only mathematical representations
3. **Face verification** prevents impersonation
4. **Cannot reverse engineer** face from descriptor (one-way process)
5. **Privacy compliant** - no biometric images stored

## Future Enhancements

- Add multiple face captures during registration for better accuracy
- Implement face re-verification if verification fails multiple times
- Add face descriptor encryption for extra security
- Support for face descriptor updates (re-registration)

