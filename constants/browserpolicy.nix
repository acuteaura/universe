let
  chromeExtensions = {
    ExtensionInstallForcelist = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin; Chrome Web Store
      "cdglnehniifkbagbbombnjghhcihifij" # Kagi
    ];
  };
in {
  # https://chromeenterprise.google/policies/
  chrome =
    chromeExtensions
    // {
      ExtensionManifestV2Availability = 2;
      # Content Settings
      DefaultGeolocationSetting = 2;
      DefaultNotificationsSetting = 2;
      DefaultLocalFontsSetting = 2;
      DefaultSensorsSetting = 2;
      DefaultSerialGuardSetting = 2;
      # Cloud Reporting
      CloudReportingEnabled = false;
      # Password
      PasswordManagerEnabled = false;
      PasswordSharingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      # Quick Answers
      QuickAnswersEnabled = false;
      # Safe Browsing
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingSurveysEnabled = false;
      SafeBrowsingDeepScanningEnabled = false;
      # User and device reporting
      DeviceActivityHeartbeatEnabled = false;
      DeviceMetricsReportingEnabled = false;
      HeartbeatEnabled = false;
      LogUploadEnabled = false;
      ReportAppInventory = [""];
      ReportDeviceActivityTimes = false;
      ReportDeviceAppInfo = false;
      ReportDeviceSystemInfo = false;
      ReportDeviceUsers = false;
      ReportWebsiteTelemetry = [""];
      # Miscellaneous
      AlternateErrorPagesEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BrowserGuestModeEnabled = false;
      BrowserSignin = 0;
      BuiltInDnsClientEnabled = false;
      DefaultBrowserSettingEnabled = false;
      MetricsReportingEnabled = false;
      ParcelTrackingEnabled = false;
      RelatedWebsiteSetsEnabled = false;
      ShoppingListEnabled = false;
      SyncDisabled = true;
    };

  # https://support.brave.com/hc/en-us/articles/360039248271-Group-Policy
  brave =
    chromeExtensions
    // {
      # Cloud Reporting
      CloudReportingEnabled = false;
      # Password
      PasswordManagerEnabled = false;
      PasswordSharingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      # Safe Browsing
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingSurveysEnabled = false;
      SafeBrowsingDeepScanningEnabled = false;
      # Miscellaneous
      AlternateErrorPagesEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BrowserGuestModeEnabled = false;
      BrowserSignin = 0;
      BuiltInDnsClientEnabled = false;
      DefaultBrowserSettingEnabled = false;
      MetricsReportingEnabled = false;
      RelatedWebsiteSetsEnabled = false;
      ShoppingListEnabled = false;
      SyncDisabled = false;
      # Brave-specific
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true; # brave 1.82
      BraveP3AEnabled = false; # brave 1.83
      BraveRewardsDisabled = true;
      BraveSpeedreaderEnabled = false; # brave 1.82
      BraveStatsPingEnabled = false; # brave 1.83
      BraveTalkDisabled = true; # brave 1.82
      BraveVPNDisabled = true;
      BraveWalletDisabled = true;
      BraveWaybackMachineEnabled = false; # brave 1.82
      BraveWebDiscoveryEnabled = false; # brave 1.83
      TorDisabled = true;
    };

  # https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies
  edge =
    chromeExtensions
    // {
      ExtensionManifestV2Availability = 2;
      # Content Settings
      DefaultGeolocationSetting = 2;
      DefaultNotificationsSetting = 2;
      DefaultLocalFontsSetting = 2;
      DefaultSensorsSetting = 2;
      DefaultSerialGuardSetting = 2;
      # Cloud Reporting
      CloudReportingEnabled = false;
      # Password
      PasswordManagerEnabled = false;
      PasswordSharingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      # Quick Answers
      QuickAnswersEnabled = false;
      # Safe Browsing
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingSurveysEnabled = false;
      SafeBrowsingDeepScanningEnabled = false;
      # User and device reporting
      DeviceActivityHeartbeatEnabled = false;
      DeviceMetricsReportingEnabled = false;
      HeartbeatEnabled = false;
      LogUploadEnabled = false;
      ReportAppInventory = [""];
      ReportDeviceActivityTimes = false;
      ReportDeviceAppInfo = false;
      ReportDeviceSystemInfo = false;
      ReportDeviceUsers = false;
      ReportWebsiteTelemetry = [""];
      # Miscellaneous
      AlternateErrorPagesEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BrowserSignin = 0;
      BuiltInDnsClientEnabled = false;
      DefaultBrowserSettingEnabled = false;
      MetricsReportingEnabled = false;
      ParcelTrackingEnabled = false;
      ShoppingListEnabled = false;
      SyncDisabled = true;
      # Application Guard
      ApplicationGuardFavoritesSyncEnabled = false;
      ApplicationGuardPassiveModeEnabled = false;
      ApplicationGuardTrafficIdentificationEnabled = false;
      ApplicationGuardUploadBlockingEnabled = false;
      # Edge Typo Protection settings
      TyposquattingCheckerEnabled = false;
      # Edge Workspaces
      EdgeWorkspacesEnabled = false;
      # Extensions
      ControlDefaultStateOfAllowExtensionFromOtherStoresSettingEnabled = true;
      BlockExternalExtensions = false;
      # Games
      GamerModeEnabled = false;
      # Generative AI
      GenAILocalFoundationalModelSettings = 1;
      # Identity & SignIn
      ImplicitSignInEnabled = false;
      LinkedAccountEnabled = false; # OBSOLETE
      ProactiveAuthWorkflowEnabled = false;
      SeamlessWebToBrowserSignInEnabled = false;
      WebToBrowserSignInEnabled = false;
      # Immersive Reader
      ImmersiveReaderGrammarToolsEnabled = false; # OBSOLETE
      ImmersiveReaderPictureDictionaryEnabled = false; # OBSOLETE
      # Manageability
      EdgeManagementEnabled = false;
      EdgeManagementExtensionsFeedbackEnabled = false;
      MAMEnabled = false;
      # Password Manager and Protection
      PasswordMonitorAllowed = false;
      PasswordExportEnabled = false;
      PasswordGeneratorEnabled = false;
      PasswordRevealEnabled = false;
      # Performance
      ExtensionsPerformanceDetectorEnabled = false;
      PerformanceDetectorEnabled = false;
      PinBrowserEssentialsToolbarButton = false;
      StartupBoostEnabled = false;
      # Related Website Sets
      RelatedWebsiteSetsEnabled = false;
      # Scareware Blocker
      ScarewareBlockerProtectionEnabled = false;
      # SmartScreen settings
      SmartScreenEnabled = false;
      SmartScreenPuaEnabled = false;
      SmartScreenForTrustedDownloadsEnabled = false;
      SmartScreenDnsRequestsEnabled = false;
      # Startup, home page and new tab page
      NewTabPageAllowedBackgroundTypes = 3;
      NewTabPageAppLauncherEnabled = false;
      NewTabPageBingChatEnabled = false;
      NewTabPageContentEnabled = false;
      NewTabPageHideDefaultTopSites = true;
      NewTabPagePrerenderEnabled = false;
      NewTabPageQuickLinksEnabled = false;
      NewTabPageLocation = "about:blank";
      # Additional
      AADWebSiteSSOUsingThisProfileEnabled = false;
      AccessibilityImageLabelsEnabled = false;
      AddressBarMicrosoftSearchInBingProviderEnabled = false; # OBSOLETE
      AIGenThemesEnabled = false;
      AllowGamesMenu = false;
      AmbientAuthenticationInPrivateModesEnabled = false;
      AutomaticHttpsDefault = true; # improved QoL
      BingAdsSuppression = true;
      BrowserGuestModeEnabled = false;
      ComposeInlineEnabled = false;
      ConfigureDoNotTrack = true;
      CryptoWalletEnabled = false; # OBSOLETE
      DiagnosticData = 0;
      Edge3PSerpTelemetryEnabled = false;
      EdgeAssetDeliveryServiceEnabled = false;
      EdgeCollectionsEnabled = false;
      EdgeDiscoverEnabled = false; # OBSOLETE
      EdgeEDropEnabled = false;
      EdgeEnhanceImagesEnabled = false; # OBSOLETE
      EdgeFollowEnabled = false; # OBSOLETE
      EdgeHistoryAISearchEnabled = false;
      EdgeShoppingAssistantEnabled = false;
      EdgeWalletCheckoutEnabled = false;
      EdgeWalletEtreeEnabled = false;
      ExperimentationAndConfigurationServiceControl = 0;
      ForceSync = false;
      HttpsUpgradesEnabled = true;
      HubsSidebarEnabled = false;
      ImageEditorServiceEnabled = false; # OBSOLETE
      InAppSupportEnabled = false;
      InternetExplorerIntegrationLevel = 0;
      LiveCaptionsAllowed = false;
      LiveTranslationAllowed = false;
      LocalProvidersEnabled = false;
      MathSolverEnabled = false; # OBSOLETE
      MicrosoftEdgeInsiderPromotionEnabled = false;
      MicrosoftEditorProofingEnabled = false;
      MicrosoftEditorSynonymsEnabled = false;
      MicrosoftOfficeMenuEnabled = false;
      NonRemovableProfileEnabled = false; # Used with BrowserSignin=0
      OutlookHubMenuEnabled = false;
      PaymentMethodQueryEnabled = false;
      PersonalizationReportingEnabled = false;
      PersonalizeTopSitesInCustomizeSidebarEnabled = false;
      PictureInPictureOverlayEnabled = false;
      ProactiveAuthEnabled = false; # OBSOLETE
      PromotionalTabsEnabled = false; # DEPRECATED
      PromptForDownloadLocation = false; # improved QoL
      ReadAloudEnabled = false;
      ResolveNavigationErrorsUseWebService = false;
      SearchSuggestEnabled = false;
      SharedLinksEnabled = false;
      ShowAcrobatSubscriptionButton = false;
      ShowMicrosoftRewards = false;
      ShowOfficeShortcutInFavoritesBar = false;
      ShowRecommendationsEnabled = false;
      SpeechRecognitionEnabled = false;
      SpellcheckEnabled = false;
      StandaloneHubsSidebarEnabled = false;
      TabServiceEnabled = false;
      TextPredictionEnabled = false;
      TranslateEnabled = true; # improved QoL
      TravelAssistanceEnabled = false; # OBSOLETE
      UploadFromPhoneEnabled = false;
      UrlDiagnosticDataEnabled = false;
      UserFeedbackAllowed = false;
      VisualSearchEnabled = false;
      WalletDonationEnabled = false;
      WebWidgetAllowed = false; # DEPRECATED
    };
}
