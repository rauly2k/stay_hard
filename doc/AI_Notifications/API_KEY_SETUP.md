# AI Notifications API Key Setup

This guide explains how to configure your Gemini API key to test the AI notification system with real AI-generated messages.

## Why You Need an API Key

The AI notification system uses Google's Gemini API to generate personalized, context-aware notification messages. Without an API key, the testing page will fall back to simple mock messages that don't reflect your updated prompts and persona system.

## Getting Your API Key

1. **Visit Google AI Studio**
   - Go to: https://makersuite.google.com/app/apikey
   - Sign in with your Google account

2. **Create a New API Key**
   - Click "Create API Key"
   - Select or create a Google Cloud project
   - Copy the generated API key (it starts with "AIza...")

3. **Keep Your Key Secure**
   - Don't commit your API key to version control
   - Don't share your API key publicly
   - The free tier includes generous usage limits

## Configuring the API Key

### Option 1: Environment Variable (Recommended for Development)

1. Create a `.env` file in the root of your project (if not exists):
   ```bash
   # .env
   GEMINI_API_KEY=your_actual_api_key_here
   ```

2. Make sure `.env` is in your `.gitignore` file

3. Run your app with the environment variable:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_actual_api_key_here
   ```

### Option 2: Direct Code Update (Quick Testing)

1. Open the file: `lib/features/ai_notifications/presentation/providers/ai_notification_providers.dart`

2. Find the `geminiApiKeyProvider`:
   ```dart
   final geminiApiKeyProvider = Provider<String>((ref) {
     const apiKey = String.fromEnvironment('GEMINI_API_KEY',
       defaultValue: 'YOUR_API_KEY_HERE');
     return apiKey;
   });
   ```

3. Replace `'YOUR_API_KEY_HERE'` with your actual API key:
   ```dart
   final geminiApiKeyProvider = Provider<String>((ref) {
     const apiKey = String.fromEnvironment('GEMINI_API_KEY',
       defaultValue: 'AIzaSyC...');  // Your actual key
     return apiKey;
   });
   ```

4. **IMPORTANT**: Don't commit this change! Revert it before committing.

### Option 3: Production Setup (Firebase Remote Config)

For production use, store the API key in Firebase Remote Config:

1. Add the key to Firebase Remote Config in your Firebase Console
2. Fetch it at runtime:
   ```dart
   final remoteConfig = FirebaseRemoteConfig.instance;
   await remoteConfig.fetchAndActivate();
   final apiKey = remoteConfig.getString('gemini_api_key');
   ```

## Testing the Integration

1. **Navigate to Settings**
   - Open the app
   - Go to Settings → AI Notifications

2. **Open Test Page**
   - Tap "Test Notifications" button

3. **Verify API Key Status**
   - If configured correctly, you'll see: "Using real AI generation with your updated prompts" (green)
   - If not configured, you'll see an orange warning banner with setup instructions

4. **Generate Test Notifications**
   - Select an AI Style (e.g., "Drill Sergeant", "Friendly Coach")
   - Choose an Intervention Category
   - Tap "Generate & Send Test"
   - The message will be generated using your updated prompts from `ai_notif_sources.md`

## What You're Testing

With a valid API key, the system uses:

- **Persona Repository**: All 8 AI archetypes with their reference quotes and system prompts
- **Prompt Builder**: Advanced prompt engineering with role definition and context injection
- **Updated Training Data**: All the reference quotes and scenario-specific examples from your `ai_notif_sources.md` file
- **Real-time Context**: Mock notification contexts that simulate real user scenarios

## Troubleshooting

### "API Key Required" Warning Appears

**Problem**: The orange warning banner shows up
**Solution**:
- Check that you've set the API key correctly
- Verify the key is not still "YOUR_API_KEY_HERE"
- Make sure the key starts with "AIza"

### Error: "API key not valid"

**Problem**: Gemini API returns authentication error
**Solution**:
- Verify you copied the entire API key
- Check that the API key is enabled in Google Cloud Console
- Ensure the Gemini API is enabled for your project

### Fallback Messages Still Showing

**Problem**: Simple mock messages appear instead of AI-generated ones
**Solution**:
- Check the console logs for error messages
- Verify internet connectivity
- Check that `google_generative_ai` package is installed
- Review the error message in the debug console

### Rate Limiting

**Problem**: "Please wait X seconds" message appears
**Solution**:
- The testing page has a 20-second cooldown between tests of the same category
- This prevents excessive API usage during testing
- Wait for the cooldown period to expire

## API Usage and Costs

- **Free Tier**: Google provides generous free tier limits
- **Rate Limits**: 60 requests per minute
- **Quota**: Check current usage at https://console.cloud.google.com/

## Next Steps

Once your API key is configured:

1. Test each of the 8 AI archetypes
2. Try all 7 intervention categories
3. Verify the messages match the tone and style from your updated prompts
4. Check that context (streaks, habits, time of day) is being used appropriately
5. Compare with the reference examples in `ai_notif_sources.md`

## Security Best Practices

✅ **DO**:
- Use environment variables for development
- Use Firebase Remote Config for production
- Add `.env` to `.gitignore`
- Rotate keys if accidentally committed

❌ **DON'T**:
- Hardcode API keys in source code
- Commit API keys to version control
- Share API keys in screenshots or documentation
- Use production keys in development

---

For more information about the AI notification system, see:
- [AI_Notification_System_Specification.md](./AI_Notification_System_Specification.md)
- [Implementation_Quick_Start.md](./Implementation_Quick_Start.md)
- [ai_notif_sources.md](./ai_notif_sources.md)
