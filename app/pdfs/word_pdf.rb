class WordPdf < Prawn::Document
  def initialize words
    super()
    @words = Word.order("id DESC").all
    show_table_word
  end

  def show_table_word
    text I18n.t "words.index.title"
    table init_table_data do
      row(0).font_style = :bold
      column(0..1).align = :center
      self.row_colors = ["DDDDDD","FFFFFF"]
      self.header = true
    end
  end

  def init_table_data
    [[I18n.t("words.list.content"),
      I18n.t("words.list.meaning"),
      I18n.t("words.list.category"),
      I18n.t("words.list.created_at")]]
    @words.map do |word|
      [word.content,
        word.find_answer.map {|str| "#{str.content}"}.join(", "),
          word.category.name, word.created_at.to_s(:long)]
    end
  end
end
