class GraphController < ApplicationController
  include AnswersHelper

  caches_page :show

  # To make caching easier, add a line like this to config/routes.rb:
  # map.graph "graph/:action/:id/image.png", :controller => "graph"
  #
  # Then reference it with the named route:
  #   image_tag graph_url(:action => 'show', :id => 42)

  def show
    @answers = Answer.summary(params[:id])
    g = Gruff::Mini::Pie.new 200
    # Uncomment to use your own theme or font
    # See http://colourlovers.com or http://www.firewheeldesign.com/widgets/ for color ideas
    g.theme = {
      :colors => %w[#336699 #FF5580 #339933 #FFF804 #cc99cc #cf5910 #000000],
      :marker_color => '#000000',
      :font_color => '#000000',
      :background_colors => 'transparent'
    }
    #g.font = File.expand_path('artwork/fonts/VeraBd.ttf', RAILS_ROOT)
    g.font = '/usr/share/fonts/truetype/ipafont/ipagp.ttf'
    g.zero_degree = -90

    g.title = @answers.first.body
    @answers.each do |answer|
      g.data(_(answer.label), answer.count.to_i)
    end

    send_data(g.to_blob,
              :disposition => 'inline',
              :type => 'image/png',
              :filename => "image.png")
  end

end
