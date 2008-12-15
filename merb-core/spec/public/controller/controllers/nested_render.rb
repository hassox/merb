module Merb::Test::Fixtures
  
  class RenderPresenter
    def to_html1(*args); "<div class='to_html1'>:to_html1</div>"; end
    def to_html2(*args); "<div class='to_html2'>:to_html2</div>"; end
    def to_html3(*args); "<div class='to_html3'>:to_html3</div>"; end
    def to_html4(*args); "<div class='to_html4'>:to_html4</div>"; end
  end

  module Controllers
    
    class Testing < Merb::Controller
      self._template_root = File.dirname(__FILE__) / "views"
    end
    
    class NestedRender < Testing
      provides :html1, :html2, :html3, :html4
      
      def index
        render
      end
      
      def complex
        render
      end
      
      def show
        display RenderPresenter.new
      end
      
      def complex_show
        display RenderPresenter.new
      end
      
    end
    
  end # Abstract
end # Merb::Test::Fixtures