module ButtonComponents
  def submit_centred(*args, &block)
    template.content_tag :div, :class => 'form-group' do
      template.content_tag :div, :class => 'col-sm-offset-4 col-sm-8' do
        options = args.extract_options!
        args << options
        submit(*args, &block)
      end
    end
  end
end

SimpleForm::FormBuilder.send :include, ButtonComponents
