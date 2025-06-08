(define-map moods
  ((user principal))
  ((entries (list 0))) )

(define-public (add-mood (text (string-ascii 280)) (cid (optional (string-ascii 100))))
  (let (
        (user tx-sender)
        (entry { text: text, timestamp: (get-block-info? time), cid: cid }))
    (begin
      (asserts! (<= (len entries) u100) (err u1))
      (map-set moods { user: user } { entries: (cons entry (default-to entries (map-get? moods { user: user }))) })
      (ok true))))

(define-read-only (get-moods)
  (unwrap-panic (map-get? moods { user: tx-sender })))
