require_relative 'complete_me'

Shoes.app(width:500) do
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

 flow :width => 500, :height => 500 do
    background './pic2.jpg'
    @fortune_teller = para "cat got your tongue?"
    @fortune_teller.style(stroke:rgb(240, 248, 255), font:"Trattatello 70px", align:"center" )
    stack :width => "100%" do
        @response_choose = para ""
        @response_choose.style(stroke:rgb(240, 248, 255), align:"center", font:"Helvetica")
    end
    stack do
        @message_choose = para "enter the first couple of letters"
        @message_choose.style(stroke:rgb(240, 248, 255), font:"Helvetica", align:"center")

        @edit_line_choose = edit_line.style(displace_left:150)
        @choose_button = button "substring" do
            @message_choose.text = "you chose #{@edit_line_choose.text}"
            @response_choose.text =
                "you're probably thinking of: #{completion.suggest("#{@edit_line_choose.text}").join(", ")}"
        end
        @choose_button.style(displace_left:200)
    end

    stack do
        @message_delete = para "hate a suggestion? delete it."
        @message_delete.style(stroke:rgb(240, 248, 255), align:"center")
        @edit_line_delete = edit_line.style(displace_left:150)

        @delete_button = button "fuck this word" do
            @message_delete.text = "you deleted #{@edit_line_delete.text}"
            completion.delete("#{@edit_line_delete.text}")
            @response_choose.text =
                "you're probably thinking of: #{completion.suggest("#{@edit_line_choose.text}").join(", ")}"
        end
        @delete_button.style(displace_left:175)
    end

    stack do
        @message_suggest = para "love a suggestion?"
        @message_suggest.style(stroke:rgb(240, 248, 255), align:"center")
        @edit_line_suggest = edit_line.style(displace_left:150)
        @suggest_button = button "this is a great word" do
            @message_suggest.text = "you liked #{@edit_line_suggest.text}"
            completion.select("#{@edit_line_choose.text}","#{@edit_line_suggest.text}")
            @response_choose.text =
                "you're probably thinking of: #{completion.suggest("#{@edit_line_choose.text}").join(", ")}"
        end
        @suggest_button.style(displace_left:150)
    end
  end
end
