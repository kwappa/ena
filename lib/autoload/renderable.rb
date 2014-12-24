module Renderable
  def renderer
    @renderer ||= ::Qiita::Markdown::Processor.new
  end

  def render(field)
    renderer.call(self.send(field))[:output].to_s
  end
end
