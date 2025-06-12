# HubSpot Forms Setup Guide

## Overview
This guide walks you through setting up HubSpot forms for Cloud Data Consulting website lead capture.

## Forms We Need to Create

### 1. **General Contact Form** (Primary)
- **Purpose**: Schedule Consultation, General Inquiries
- **Button Text**: "Schedule Consultation", "Contact Us"
- **Fields Needed**:
  - First Name (required)
  - Last Name (required) 
  - Email (required)
  - Company (required)
  - Phone Number (optional)
  - Message/Project Details (text area)
  - How did you hear about us? (dropdown)

### 2. **AI Readiness Assessment Form**
- **Purpose**: Get Your AI Readiness Score
- **Button Text**: "Get Your AI Readiness Score", "Start Assessment"
- **Fields Needed**:
  - First Name (required)
  - Last Name (required)
  - Email (required)
  - Company (required)
  - Industry (dropdown)
  - Company Size (dropdown)
  - Current AI Initiatives (checkbox)
  - Primary Challenge (dropdown)

### 3. **Service-Specific Forms** (Optional for later)
- Individual forms for each service page
- Pre-populate "Service Interest" field

## Step-by-Step HubSpot Setup

### Step 1: Access HubSpot Forms
1. Log into your HubSpot account
2. Go to **Marketing** → **Lead Capture** → **Forms**
3. Click **"Create form"**

### Step 2: Choose Form Type
- Select **"Embedded form"** (for website integration)
- Choose **"Regular form"** template

### Step 3: Build the General Contact Form

#### Form Fields:
```
First Name - Single-line text (required)
Last Name - Single-line text (required)
Email - Email (required)
Company - Single-line text (required)
Phone Number - Phone number (optional)
Message - Multi-line text (optional)
  Placeholder: "Tell us about your AI/data challenges..."
How did you hear about us? - Dropdown (optional)
  Options: Google Search, LinkedIn, Referral, Conference, Other
```

#### Form Settings:
- **Form Name**: "CDC - General Contact Form"
- **Language**: English
- **Submit Button Text**: "Schedule Consultation"

#### Options Tab:
- **Redirect**: Thank you page (we'll create this)
- **Follow-up Email**: Optional welcome email
- **Notifications**: Email to your team when form submitted

### Step 4: Build AI Assessment Form

#### Form Fields:
```
First Name - Single-line text (required)
Last Name - Single-line text (required)
Email - Email (required)
Company - Single-line text (required)
Industry - Dropdown (required)
  Options: Healthcare, Financial Services, Manufacturing, Retail, Technology, Other
Company Size - Dropdown (required)
  Options: 1-50, 51-200, 201-1000, 1000+
Current AI Initiatives - Checkbox (optional)
  Options: ML/Analytics, Automation, Chatbots, Predictive Analytics, None yet
Primary Data Challenge - Dropdown (required)
  Options: Data Quality, Data Silos, Legacy Systems, Lack of Strategy, Cost/Performance
```

#### Form Settings:
- **Form Name**: "CDC - AI Readiness Assessment"
- **Submit Button Text**: "Get My AI Readiness Score"

## Step 5: Get Embed Codes

After creating each form:
1. Click **"Publish"**
2. Select **"Embed"** 
3. Copy the **JavaScript embed code**
4. We'll integrate these into the website

## Step 6: Create Thank You Pages

You'll want to create simple thank you pages:
- `/thank-you-contact.html`
- `/thank-you-assessment.html`

## Implementation Plan

### Phase 1: Basic Setup
1. Create General Contact Form in HubSpot
2. Get embed code
3. Create contact.html page with embedded form
4. Update navigation and CTAs

### Phase 2: Assessment Form
1. Create AI Assessment Form in HubSpot
2. Get embed code  
3. Create assessment landing page
4. Update "Get AI Readiness Score" buttons

### Phase 3: Optimization
1. Add tracking pixels
2. Create automated follow-up sequences
3. Set up lead scoring
4. Create service-specific forms

## Next Steps

1. **You**: Create the General Contact Form in HubSpot following the field specs above
2. **Me**: Create the contact.html page structure ready for your embed code
3. **Together**: Integrate and test the form

Let me know when you have the HubSpot form created and I'll help integrate it!