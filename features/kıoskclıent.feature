Feature: Kiosk Modülü Gereksinim Analizi

  Scenario: UC-K1 (Kiosk Kimlik Doğrulama) Analizi
    Given Analiz edilecek BDD metni şudur:
      """
      Feature: Kiosk User Authentication (UC-K1)
        As a Kiosk User
        I want to log in using my RF Card or QR Code
        So that I can access my account details and balance
        
        Background:
          Given the Kiosk terminal is active
          And the Kiosk is connected to the Backend Server
          And the user is on the Kiosk welcome screen
          
        # Basic Flow: Başarılı Giriş (RF ve QR için ortak yapı)
        Scenario Outline: Successful login via scanning method
          When the user scans a valid "<scan_method>"
          Then the system should send the ID data to the Backend Authentication Service
          And the Backend should verify the user credentials
          And the Kiosk should receive user details and "current balance"
          And the system should redirect the user to the Main Menu
          
          Examples:
            | scan_method |
            | RF Card     |
            | QR Code     |
            
        # Alternatif Akış A1: Okuma Hatası (Donanımsal veya bozuk kart)
        Scenario: Card or Code cannot be read
          When the user attempts to scan an unreadable or damaged RF Card/QR Code
          Then the system should fail to capture the ID
          And the system should display a "Read error, please try again" warning
          And the user should remain on the welcome screen to retry
          
        # Alternatif Akış A2: Kullanıcı Bulunamadı (Geçerli kart ama kayıtsız)
        Scenario: User not found in the database
          When the user scans a valid RF Card or QR Code
          But the Backend responds that the user is not registered
          Then the system should display a "User not registered" error message
          And the system should not allow access to the menu
          
        # İstisna Akış I1: Backend Bağlantı Hatası
        Scenario: System is offline during login attempt
          When the user scans an RF Card or QR Code
          But the connection to the Backend Service is lost
          Then the system should display an "Offline mode - Service unavailable" error message
          And the login attempt should be terminated
      """
    When Yapay Zeka bu BDD senaryosunu analiz edip teknik gereksinimleri çıkardığında
    Then Sonuç "Requirements_UC-K1.md" dosyasına kaydedilmeli
    And Dosyanın içinde en az "1" adet Fonksiyonel Gereksinim (FR) olmalı

  Scenario: UC-K2 (Oyun Seçimi) Analizi
    Given Analiz edilecek BDD metni şudur:
      """
      Feature: Game Selection (UC-K2)
        As a logged-in Kiosk User
        I want to select a game and configure its settings (duration, difficulty)
        So that I can play a game that matches my preferences
        
        Background:
          Given the user is logged into the Kiosk
          And the system displays the list of active games
          
        # Basic Flow: Başarılı Oyun ve Ayar Seçimi
        Scenario Outline: User selects a game and configures parameters
          When the user selects the game "<game_name>"
          Then the system should retrieve game details (price, duration options, difficulty) from the Backend
          When the user selects "<duration>" and "<difficulty>"
          And confirms the selection
          Then the system should save the configuration
          And proceed to the "Zone Check" screen
          
          Examples:
            | game_name      | duration | difficulty |
            | Zombie Shooter | 5 mins   | Normal     |
            | Car Race       | 3 laps   | Hard       |
            
        # Alternatif Akış A1: Pasif Oyun
        Scenario: Selecting a passive game
          When the user selects a game marked as "Passive" in the system
          Then the system should display a "Game currently unavailable" message
          And the user should remain on the game list screen
          
        # İstisna Akış I1: Oyun Detayları Alınamadı (Cache Kullanımı)
        Scenario: Backend failure retrieves cached game details
          When the user selects a game
          But the Backend Game Service is unreachable
          Then the system should display the "Last known details" from the local cache
          And allow the user to proceed with default or cached settings
      """
    When Yapay Zeka bu BDD senaryosunu analiz edip teknik gereksinimleri çıkardığında
    Then Sonuç "Requirements_UC-K2.md" dosyasına kaydedilmeli
    And Dosyanın içinde en az "1" adet Fonksiyonel Gereksinim (FR) olmalı

  Scenario: UC-K3 (Zone Doluluk Kontrolü) Analizi
    Given Analiz edilecek BDD metni şudur:
      """
      Feature: Zone Capacity Check (UC-K3)
        As the Kiosk System
        I want to check if the zone is available
        So that I can prevent overcrowding before starting the game
        
        Background:
          Given the user has selected a game and configuration
          
        # Basic Flow: Zone Boş
        Scenario: Zone is available for entry
          When the Kiosk requests zone capacity status from the Backend
          And the Backend responds that the Zone is "Available"
          Then the system should allow the user to proceed to payment or game start
          
        # Alternatif Akış: Zone Dolu
        Scenario: Zone is full
          When the Kiosk requests zone capacity status from the Backend
          And the Backend responds that the Zone is "Full"
          Then the system should display a "Zone is currently full, please wait" warning
          And the system should not allow the game to start
          
        # İstisna Akış I1: Backend Yanıt Vermiyor (Cache)
        Scenario: Zone check fails due to connection error
          When the Kiosk requests zone capacity status
          But the Backend Zone Service times out
          Then the system should retrieve the "Last known status" from the cache
          And proceed based on the cached value
      """
    When Yapay Zeka bu BDD senaryosunu analiz edip teknik gereksinimleri çıkardığında
    Then Sonuç "Requirements_UC-K3.md" dosyasına kaydedilmeli
    And Dosyanın içinde en az "1" adet Fonksiyonel Gereksinim (FR) olmalı

  Scenario: UC-K4 (Oyun Başlatma) Analizi
    Given Analiz edilecek BDD metni şudur:
      """
      Feature: Game Initialization (UC-K4)
        As a User
        I want to start the game session immediately
        So that I can begin playing without delay
        
        Background:
          Given the Zone is confirmed as available
          And the user is on the "Ready to Start" screen
          
        # Basic Flow: Başarılı Başlatma
        Scenario: User starts the game successfully
          When the user clicks the "Start" button
          Then the Kiosk should send a "start session" command to the GameClient
          And the GameClient should acknowledge the command
          And the Kiosk should switch to the "Game In Progress" screen
          
        # İstisna Akış I1: GameClient Yanıt Vermiyor
        Scenario: GameClient fails to start
          When the user clicks the "Start" button
          But the GameClient does not respond within the timeout period
          Then the Kiosk should display a "Game could not be started" error message
          And the system should trigger a refund or retry mechanism
      """
    When Yapay Zeka bu BDD senaryosunu analiz edip teknik gereksinimleri çıkardığında
    Then Sonuç "Requirements_UC-K4.md" dosyasına kaydedilmeli
    And Dosyanın içinde en az "1" adet Fonksiyonel Gereksinim (FR) olmalı

  Scenario: UC-K5 (Oyun Sonu ve Skor) Analizi
    Given Analiz edilecek BDD metni şudur:
      """
      Feature: Game End and Score Processing (UC-K5)
        As a Player
        I want to see my score immediately after the game ends
        So that I can know my performance
        
        Background:
          Given the game session is in progress
          
        # Basic Flow: Oyun Sonu ve Skor Gösterimi
        Scenario: Game ends and score is displayed successfully
          When the GameClient triggers the "Game Over" event
          And sends the score data to the Backend
          Then the Backend should verify and return the processed score
          And the Kiosk should display the "Final Score" to the user
          And after a delay, the system should redirect to the Main Screen
          
        # İstisna Akış I1: Skor Gönderilemedi (Offline Mode)
        Scenario: Score upload fails due to network error
          When the GameClient triggers the "Game Over" event
          But the connection to the Backend Score Service is lost
          Then the system should save the score data "Locally"
          And queue the data for synchronization when connection is restored
          And the Kiosk should display the locally available score to the user
      """
    When Yapay Zeka bu BDD senaryosunu analiz edip teknik gereksinimleri çıkardığında
    Then Sonuç "Requirements_UC-K5.md" dosyasına kaydedilmeli
    And Dosyanın içinde en az "1" adet Fonksiyonel Gereksinim (FR) olmalı

  Scenario: UC-K6 (Bakiye Yükleme) Analizi
    Given Analiz edilecek BDD metni şudur:
      """
      Feature: User Balance Top-up (UC-K6)
        As a User
        I want to load credits to my account
        So that I can pay for games
        
        Background:
          Given the user is logged in
          And the user selects "Top-up Balance"
        
        # Basic Flow: Başarılı Bakiye Yükleme
        Scenario Outline: Successful top-up via different methods
          When the user chooses "<payment_method>" as the payment option
          And completes the payment transaction
          Then the payment information should be sent to the Backend Payment Service
          And the Backend should update the user's wallet balance
          And the Kiosk should display a "Transaction Successful" message
          And the new balance should be visible on the screen
          
          Examples:
            | payment_method |
            | Credit Card    |
            | QR Payment     |
            | Cash           |
            
        # İstisna Akış I1: Ödeme Başarısız
        Scenario: Payment transaction fails
          When the user attempts to pay
          But the Payment Gateway returns a "Transaction Failed" error
          Then the system should display a "Payment could not be processed" error message
          And the user's balance should remain unchanged
      """
    When Yapay Zeka bu BDD senaryosunu analiz edip teknik gereksinimleri çıkardığında
    Then Sonuç "Requirements_UC-K6.md" dosyasına kaydedilmeli
    And Dosyanın içinde en az "1" adet Fonksiyonel Gereksinim (FR) olmalı