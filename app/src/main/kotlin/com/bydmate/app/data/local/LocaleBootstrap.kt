package com.bydmate.app.data.local

// Default app language is Chinese: this project is built primarily for Chinese
// speakers, and DiLink head units ship with zh/en system locales (no Russian),
// so deriving the default from Locale.getDefault() would mislocalize the core
// audience. Existing users keep Russian; new installs get Chinese; English/other
// users switch manually in Settings (zh option added in PR #39).
fun decideLanguage(setupCompleted: Boolean): String =
    if (setupCompleted) "ru" else "zh"
