import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to notifications channel")
  },
  
  disconnected() {
    console.log("Disconnected from notifications channel")
  },
  
  received(data) {
    const notificationCount = document.getElementById('notification-count')
    if (notificationCount) {
      notificationCount.textContent = data.count
      notificationCount.classList.remove('hidden')
    }
    
    const notificationList = document.getElementById('notification-list')
    if (notificationList && data.notification_html) {
      const tempDiv = document.createElement('div')
      tempDiv.innerHTML = data.notification_html
      notificationList.prepend(tempDiv.firstElementChild)
    }
    
    this.showNotificationToast(data.message)
  },
  
  showNotificationToast(message) {
    const toast = document.createElement('div')
    toast.className = 'notification-toast fixed top-4 right-4 bg-blue-500 text-white p-4 rounded shadow-lg transform translate-x-full transition-transform duration-300'
    toast.innerHTML = `<div class="notification-content">${message}</div>`
    document.body.appendChild(toast)
    
    setTimeout(() => {
      toast.classList.remove('translate-x-full')
      setTimeout(() => {
        toast.classList.add('translate-x-full')
        setTimeout(() => {
          toast.remove()
        }, 300)
      }, 5000)
    }, 100)
  }
})
