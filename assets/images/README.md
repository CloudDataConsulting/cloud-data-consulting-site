# Logo and Image Assets

## 📁 Directory Structure

```
assets/images/
├── logos/          ✅ Your logo files (organized!)
├── team/           👥 Team headshots and photos
├── icons/          🎨 Custom icons and graphics
└── README.md       📖 This guide
```

## ✅ **Current Logo Setup** 

**Integrated logos:**
- **Navbar**: `Logo_small_square.svg` (40px height)
- **Footer**: `CDC_Logo_clear_1280x304px.png` (60px height, white filtered)
- **Favicon**: `Favicon_200px.png` (browser tab icon)

**Available logo files:**
- `Logo_small_square.svg` - Perfect vector logo ✅
- `CDC_Logo_clear_1280x304px.png` - High-res PNG ✅
- `CDC_Logo_shortened_large.png` - Compact version
- Multiple favicon sizes available

## 👥 **Team Photos**

**For headshots and team photos:**
- Place in `team/` folder
- Recommended size: 400x400 pixels
- Format: JPG or PNG
- Currently have: `ProfilePic_large.jpg` ✅

## 🔄 How to Add Your Logo

1. **Copy your logo files** from Google Drive to this folder
2. **Update the HTML** to reference your logo:
   ```html
   <!-- In navigation section, replace: -->
   <a href="#" class="logo">Cloud Data Consulting</a>
   
   <!-- With: -->
   <a href="#" class="logo">
       <img src="../assets/images/logo.svg" alt="Cloud Data Consulting" height="40">
   </a>
   ```

## 📏 Recommended Sizes

- **Main Logo**: 200px wide (SVG preferred for scaling)
- **Favicon**: 32x32 pixels
- **Hero Images**: 1200px wide minimum
- **Team Photos**: 300x300 pixels
- **Partner Logos**: 150px wide

## 🎨 Current Color Scheme

Your website uses these colors - ensure logos work well with them:
- Primary Blue: #3156CF
- Dark Blue: #002B7F  
- Accent Orange: #F79743
- White: #FFFFFF
- Light Gray: #F5F7FA

Let me know when you've added your logo files and I'll help integrate them!