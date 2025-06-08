;; Mood Analytics Contract
;; Provides analytics and insights for mood data

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_NO_DATA (err u2))
(define-constant ERR_INVALID_TIMEFRAME (err u3))

;; Data Variables
(define-data-var analytics-enabled bool true)

;; Data Maps
(define-map daily-mood-summary
  { date: uint }
  { total-moods: uint, happy-count: uint, sad-count: uint, neutral-count: uint })

(define-map user-mood-streaks
  { user: principal }
  { current-streak: uint, longest-streak: uint, last-mood-date: uint })

(define-map weekly-insights
  { week: uint, year: uint }
  { dominant-mood: (string-ascii 20), total-users: uint, avg-moods-per-user: uint })

;; Public Functions
(define-public (record-daily-mood (mood-type (string-ascii 20)) (user principal))
  (let (
    (today (/ (unwrap-panic (get-block-info? time u0)) u86400)) ;; Convert to days
    (current-summary (map-get? daily-mood-summary { date: today }))
    (default-summary { total-moods: u0, happy-count: u0, sad-count: u0, neutral-count: u0 }))
    (begin
      (asserts! (var-get analytics-enabled) ERR_UNAUTHORIZED)
      
      (let ((summary (default-to default-summary current-summary)))
        (map-set daily-mood-summary 
          { date: today }
          {
            total-moods: (+ (get total-moods summary) u1),
            happy-count: (+ (get happy-count summary) (if (or (is-eq mood-type "happy") (is-eq mood-type "excited") (is-eq mood-type "grateful")) u1 u0)),
            sad-count: (+ (get sad-count summary) (if (or (is-eq mood-type "sad") (is-eq mood-type "anxious")) u1 u0)),
            neutral-count: (+ (get neutral-count summary) (if (is-eq mood-type "neutral") u1 u0))
          }))
      
      ;; Update user streak
      (update-user-streak user today)
      (ok true))))

(define-private (update-user-streak (user principal) (today uint))
  (let (
    (current-streak-data (default-to { current-streak: u0, longest-streak: u0, last-mood-date: u0 } (map-get? user-mood-streaks { user: user })))
    (last-date (get last-mood-date current-streak-data))
    (current-streak (get current-streak current-streak-data))
    (longest-streak (get longest-streak current-streak-data)))
    (if (is-eq (- today last-date) u1) ;; Consecutive day
      (let ((new-current (+ current-streak u1)))
        (map-set user-mood-streaks 
          { user: user }
          {
            current-streak: new-current,
            longest-streak: (if (> new-current longest-streak) new-current longest-streak),
            last-mood-date: today
          }))
      (map-set user-mood-streaks 
        { user: user }
        {
          current-streak: u1,
          longest-streak: (if (> u1 longest-streak) u1 longest-streak),
          last-mood-date: today
        }))))

(define-public (generate-weekly-insight (week uint) (year uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (var-get analytics-enabled) ERR_UNAUTHORIZED)
    (asserts! (and (> week u0) (<= week u52)) ERR_INVALID_TIMEFRAME)
    
    ;; This is a simplified version - in practice you'd aggregate daily data
    (map-set weekly-insights
      { week: week, year: year }
      {
        dominant-mood: "happy", ;; Placeholder - would calculate from daily data
        total-users: u10,       ;; Placeholder - would count unique users
        avg-moods-per-user: u5  ;; Placeholder - would calculate average
      })
    (ok true)))

(define-public (toggle-analytics)
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (var-set analytics-enabled (not (var-get analytics-enabled)))
    (ok (var-get analytics-enabled))))

;; Read-only Functions
(define-read-only (get-daily-summary (date uint))
  (ok (map-get? daily-mood-summary { date: date })))

(define-read-only (get-user-streak (user principal))
  (ok (map-get? user-mood-streaks { user: user })))

(define-read-only (get-my-streak)
  (get-user-streak tx-sender))

(define-read-only (get-weekly-insight (week uint) (year uint))
  (ok (map-get? weekly-insights { week: week, year: year })))

(define-read-only (get-mood-trend (start-date uint) (end-date uint))
  (begin
    (asserts! (<= start-date end-date) ERR_INVALID_TIMEFRAME)
    ;; Simplified implementation - would iterate through date range
    (ok { trend: "positive", confidence: u75 })))

(define-read-only (is-analytics-enabled)
  (ok (var-get analytics-enabled)))
