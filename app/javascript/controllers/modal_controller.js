import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    // モーダルが表示されたときにスクロールを無効にする
    document.body.style.overflow = 'hidden';
  }

  disconnect() {
    // コントローラーが切断されたときにスクロールを有効にする
    document.body.style.overflow = '';
  }

  open(event) {
    if (event) event.preventDefault()
    this.modalTarget.classList.remove('hidden')
    document.body.classList.add('overflow-hidden')
  }

  close(event) {
    if (event) event.preventDefault()
    this.modalTarget.classList.add('hidden')
    document.body.classList.remove('overflow-hidden')
  }

  // モーダルの外側をクリックしたときに閉じる
  closeBackground(event) {
    if (event && this.modalTarget === event.target) {
      this.close()
    }
  }

  // Escapeキーでモーダルを閉じる
  closeWithKeyboard(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
