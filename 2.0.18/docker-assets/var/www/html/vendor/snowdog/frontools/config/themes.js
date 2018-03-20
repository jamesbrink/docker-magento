{
  "blank": {
    "src": "vendor/snowdog/theme-blank-sass",
    "dest": "pub/static/frontend/Snowdog/blank",
    "locale": ["en_US"],
    "ignore": [".test"]
  },
  "basic-child": {
    "src": "vendor/snowdog/theme-basic-child",
    "dest": "pub/static/frontend/Snowdog/basic-child",
    "locale": ["en_US"],
    "parent": "blank"
  },
  "child-with-locale-overwrites": {
    "src": "vendor/snowdog/theme-custom",
    "dest": "pub/static/frontend/Snowdog/child-with-locale-overwrites",
    "locale": ["en_US", "pl_PL"],
    "parent": "blank"
  },
  "all-possible-options": {
    "src": "vendor/snowdog/theme-all-possible-options",
    "dest": "pub/static/frontend/Snowdog/all-possible-options",
    "locale": ["en_US", "pl_PL"],
    "parent": "blank",
    "stylesDir": "web/css",
    "postcss": ["plugins.autoprefixer()"],
    "disableSuffix": true,
    "modules": {
      "Snowdog_Sample": "vendor/snowdog/module-sample"
    },
    "ignore": [
      "vendor/snowdog/module-sample/{docs,dist}/**",
      "*.xml"
    ]
  }
}
