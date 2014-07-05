module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def display_count(model_class, resultsCount)
  	content_for(:display_count) { "Displaying #{resultsCount} / #{model_class.count.nil? ? 0 : model_class.count}" }
  end
end
