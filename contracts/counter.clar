;; --------------------------------------------------
;; COUNTER SMART CONTRACT (Full, Error-Free Version)
;; --------------------------------------------------
;; Author: Your Name
;; Network: Stacks
;; Tool: Clarinet + Clarity
;;
;; Description:
;; A fully functional counter contract that supports:
;;  - Increment/decrement (by 1 or custom amount)
;;  - Reset by admin
;;  - Ownership transfer
;;  - Read-only getters
;; --------------------------------------------------

;; -------------------------------
;; Data Definitions
;; -------------------------------

(define-data-var counter uint u0)
(define-data-var admin principal tx-sender)

;; -------------------------------
;; Error Constants
;; -------------------------------

(define-constant ERR-NOT-ADMIN (err u100))
(define-constant ERR-NEGATIVE (err u101))
(define-constant ERR-ZERO (err u102))

;; -------------------------------
;; Private Helper Functions
;; -------------------------------

(define-private (require-admin (caller principal))
  (if (is-eq caller (var-get admin))
      (ok true)
      ERR-NOT-ADMIN)
)

;; -------------------------------
;; Public Functions
;; -------------------------------

;; Increment counter by 1
(define-public (increment)
  (begin
    (var-set counter (+ (var-get counter) u1))
    (print { event: "increment", by: tx-sender, new-value: (var-get counter) })
    (ok (var-get counter)))
)

;; Increment counter by custom amount
(define-public (increment-by (amount uint))
  (begin
    (asserts! (> amount u0) ERR-ZERO)
    (var-set counter (+ (var-get counter) amount))
    (print { event: "increment-by", by: tx-sender, amount: amount, new-value: (var-get counter) })
    (ok (var-get counter)))
)

;; Decrement counter by 1
(define-public (decrement)
  (if (> (var-get counter) u0)
      (begin
        (var-set counter (- (var-get counter) u1))
        (print { event: "decrement", by: tx-sender, new-value: (var-get counter) })
        (ok (var-get counter)))
      (ok u0))
)

;; Decrement by custom amount (admin only)
(define-public (decrement-by (amount uint))
  (begin
    (try! (require-admin tx-sender))
    (asserts! (> amount u0) ERR-ZERO)
    (if (>= (var-get counter) amount)
        (begin
          (var-set counter (- (var-get counter) amount))
          (print { event: "decrement-by", by: tx-sender, amount: amount, new-value: (var-get counter) })
          (ok (var-get counter)))
        ERR-NEGATIVE))
)

;; Reset counter to 0 (admin only)
(define-public (reset)
  (begin
    (try! (require-admin tx-sender))
    (var-set counter u0)
    (print { event: "reset", by: tx-sender, new-value: u0 })
    (ok u0))
)

;; Transfer admin role to another principal
(define-public (transfer-admin (new-admin principal))
  (begin
    (try! (require-admin tx-sender))
    (asserts! (not (is-eq new-admin (var-get admin))) ERR-ZERO)
    (let ((old (var-get admin)))
      (var-set admin new-admin)
      (print { event: "admin-transferred", from: old, to: new-admin })
      (ok { from: old, to: new-admin })))
)

;; -------------------------------
;; Read-Only Functions
;; -------------------------------

;; Get current counter value
(define-read-only (get-counter)
  (ok (var-get counter))
)

;; Get admin principal
(define-read-only (get-admin)
  (ok (var-get admin))
)

;; Get counter info with timestamp (demo info)
(define-read-only (get-info)
  (let ((block u0))
    {
      counter: (var-get counter),
      admin: (var-get admin),
      block-height: block
    })
)
