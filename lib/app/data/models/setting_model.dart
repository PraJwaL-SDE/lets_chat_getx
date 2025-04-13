class SettingModel {
  String chatBackgroundImagePath; // Path to the chat background image
  bool isDarkMode; // Toggle for dark mode
  bool protectChat; // Whether to enable chat protection (e.g., PIN or password)
  bool hideChat; // Option to hide the chat from the main list
  bool hideChatHistory; // Whether to hide chat history
  bool notifications; // Whether notifications are enabled
  bool showOnlineStatus; // Whether to display online status
  bool readReceipts; // Whether read receipts are enabled
  bool typingIndicator; // Whether to show typing indicators
  String chatFontSize; // Font size for chat text (e.g., small, medium, large)
  bool autoSaveMedia; // Whether to auto-save received media (images/videos)
  bool enableEndToEndEncryption; // Whether end-to-end encryption is enabled
  bool backupChats; // Whether to enable automatic chat backups
  String language; // Preferred language for the app interface

  SettingModel({
    this.chatBackgroundImagePath = "",
    this.isDarkMode = false,
    this.protectChat = false,
    this.hideChat = false,
    this.hideChatHistory = false,
    this.notifications = true,
    this.showOnlineStatus = true,
    this.readReceipts = true,
    this.typingIndicator = true,
    this.chatFontSize = "medium",
    this.autoSaveMedia = false,
    this.enableEndToEndEncryption = true,
    this.backupChats = false,
    this.language = "en", // Default to English
  });

  // Method to toggle dark mode
  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
  }

  // Method to reset all settings to default
  void resetToDefaults() {
    isDarkMode = false;
    protectChat = false;
    hideChat = false;
    hideChatHistory = false;
    notifications = true;
    showOnlineStatus = true;
    readReceipts = true;
    typingIndicator = true;
    chatFontSize = "medium";
    autoSaveMedia = false;
    enableEndToEndEncryption = true;
    backupChats = false;
    language = "en";
  }
}
