# encoding: utf-8
class Pdf < Prawn::Document

  #require 'rubygems'
  #require 'active_support/all'
  #
  #$KCODE = 'UTF8'

  Widths = [190, 190, 50, 50, 80, 150]

  Headers = ['Наименование материала, детали, узла', 'Спецификация/характеристики (ГОСТ, ТУ и т.д.)', 'Ед. изм.', 'Кол-во', 'Желаемая дата поступления', 'Рекомендуемый поставщик']


  def initialize()
    super(top_margin: 20, :page_layout => :landscape)
   end

  def row(n1, n2, n3, n4, n5, n6)
    row = [n1, n2, n3, n4, n5, n6]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2
    end
  end



  def to_pdf(supply, supply_data, user)

    font_families.update(
        "Verdana" => {
            :bold => "public/fonts/verdanab.ttf",
            :italic => "public/fonts/verdanai.ttf",
            :normal  => "public/fonts/verdana.ttf" })
    font "Verdana", :size => 10

    data = []
    items = supply_data.each do |item|
      data << row( item.name, item.spec, item.measure, item.cnt, item.estimated_date, item.supplier )
    end

    span(600, :position => :center) do
      text "Заявка на приобретение МТЦ _______________________________________ на ____________2013 г."
    end
    text "
         "

    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[ffffff ffffff]) do
      row(0).style :background_color => 'ffffff', :text_color => '000000'

    end

    text '
         '
    text '
         '

    span(600, :position => :center) do
      text "Заявку составил: ___________________________/__________/  '___'____________2013 г."
    end
    text '
         '

    span(600, :position => :center) do
      text "Согласовал:     ___________________________/__________/  '___'____________2013 г."
    end
    text '
         '

    span(600, :position => :center) do
      text "Получил:        ___________________________/__________/  '___'____________2013 г."
    end
    text '
         '

    #span(600, :position => :center) do
    #  text "Получил: #{user.position} #{user.f_name} #{(user.i_name.to_s[0]||"")}#{user.o_name.to_s[0]||""}  /__________/  '___'____________2013 г."
    #end
    #text '
    #     '



    render

  end





end
