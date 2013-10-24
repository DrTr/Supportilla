module Supportilla
  module ApplicationHelper
    def parent_layout(layout)
      @view_flow.set(:layout,output_buffer)
      self.output_buffer = render(file: "layouts/#{layout}")
    end  
    
    def current_staff
      @current_staff ||= Staff.find_by_id(session[:staff_id]) if session[:staff_id]
    end
  end
end
