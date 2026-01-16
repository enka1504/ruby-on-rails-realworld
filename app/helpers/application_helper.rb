module ApplicationHelper
  def status_color(status)
    case status
    when 'pending'
      'warning'
    when 'in_progress'
      'info'
    when 'completed'
      'success'
    else
      'secondary'
    end
  end
  
  def priority_color(priority)
    case priority
    when 1
      'secondary'
    when 2
      'success'
    when 3
      'primary'
    when 4
      'warning'
    when 5
      'danger'
    else
      'secondary'
    end
  end
end