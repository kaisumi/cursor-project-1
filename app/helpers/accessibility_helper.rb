module AccessibilityHelper
  def sr_only(text)
    content_tag(:span, text, class: "sr-only")
  end
  
  def aria_label(text)
    { "aria-label" => text }
  end
  
  def aria_described_by(id)
    { "aria-describedby" => id }
  end
  
  def aria_live(level = "polite")
    { "aria-live" => level }
  end
  
  def aria_expanded(expanded = false)
    { "aria-expanded" => expanded.to_s }
  end
  
  def aria_hidden(hidden = true)
    { "aria-hidden" => hidden.to_s }
  end
  
  def aria_controls(id)
    { "aria-controls" => id }
  end
  
  def keyboard_nav(element, options = {})
    options = {
      tabindex: "0",
      role: "button",
      onkeydown: "if(event.key === ' ' || event.key === 'Enter') { event.preventDefault(); this.click(); }"
    }.merge(options)
    
    element.html_safe
  end
end
