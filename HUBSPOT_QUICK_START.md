# HubSpot Forms Quick Start Guide

## 🎯 What We've Built

I've created the contact page structure ready for your HubSpot form. Here's what's ready:
- **Contact page** (`/src/contact.html`) with placeholder for HubSpot form
- **Thank you page** (`/src/thank-you.html`) for form submissions
- **Styled form container** that will automatically style your HubSpot form

## 📋 Your HubSpot Setup Checklist

### Step 1: Create Your Form in HubSpot
1. **Log into HubSpot** → Marketing → Lead Capture → Forms
2. **Click "Create form"** → Choose "Embedded form" 
3. **Add these fields:**
   - First Name (required)
   - Last Name (required)  
   - Email (required)
   - Company (required)
   - Phone Number (optional)
   - Message (multi-line text, optional)

### Step 2: Configure Form Settings
- **Form Name**: "CDC - General Contact Form"
- **Submit Button Text**: "Schedule Consultation"
- **Thank You**: Set redirect to `https://yourdomain.com/thank-you.html`
- **Notifications**: Enable email notifications to your team

### Step 3: Get Your Embed Code
1. **Click "Publish"** when form is ready
2. **Select "Embed"** tab
3. **Copy the JavaScript code** (looks like this):
```html
<script charset="utf-8" type="text/javascript" src="//js.hsforms.net/forms/v2.js"></script>
<script>
  hbspt.forms.create({
    region: "na1",
    portalId: "YOUR_PORTAL_ID",
    formId: "YOUR_FORM_ID"
  });
</script>
```

### Step 4: Add Code to Website
1. **Open** `/src/contact.html`
2. **Find this section** (around line 285):
```html
<!-- HubSpot Form Embed Will Go Here -->
<div id="hubspot-form-contact" class="hubspot-form">
    <!-- REPLACE THIS COMMENT WITH YOUR HUBSPOT EMBED CODE -->
```
3. **Replace the placeholder** with your HubSpot embed code
4. **Save the file**

## 🧪 Testing Your Form

### Test Steps:
1. **Open** `contact.html` in browser  
2. **Fill out** the form with test data
3. **Submit** and verify redirect to thank you page
4. **Check** HubSpot contacts to see if submission appeared
5. **Verify** email notifications are working

### If Form Doesn't Appear:
- Check browser console for JavaScript errors
- Verify HubSpot portal ID and form ID are correct
- Ensure your HubSpot account has form creation permissions

## 🔄 Next Steps After HubSpot is Working

### Update CTA Buttons (I'll help with this):
Once your contact form is working, we'll update all the "Schedule Consultation" buttons to link to `contact.html`:

- Homepage hero CTA
- Service page CTAs  
- About page CTA
- Footer contact links

### Create AI Assessment Form:
We'll create a second HubSpot form specifically for "Get Your AI Readiness Score" with these fields:
- Basic contact info
- Company size
- Industry
- Current AI initiatives
- Primary data challenges

## 📞 Need Help?

**If you get stuck:**
1. Send me the embed code - I can help integrate it
2. Share any error messages from browser console
3. Let me know if you need help with HubSpot form settings

**Current Status:**
- ✅ Contact page structure ready
- ✅ Thank you page created  
- ✅ Form styling prepared
- ⏳ Waiting for your HubSpot form embed code

Let me know when you have the HubSpot form created and I'll help you integrate it!