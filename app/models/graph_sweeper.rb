class GraphSweeper < ActionController::Caching::Sweeper
  observe Answer

  def after_save(record)
    expire_image(record.question_id)
  end

  def after_update(record)
    expire_image(record.question_id)
  end

  def after_destroy(record)
    expire_image(record.question_id)
  end

  private

  def expire_image(id)
    expire_page graph_url(:action => 'show', :id => id,
                          :only_path => true, :skip_relative_url_root => true)
  end

end
