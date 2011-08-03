require 'jasmine/files_list'

module Jasmine
  class TemplateWriter
    class << self
      def write!(files_list)
        output = [
          [ "specrunner.#{$$}.html", files_list.files_to_html ]
        ]

        output.unshift([ "specrunner.#{$$}.filter.html", files_list.filtered_files_to_html ]) if files_list.filtered?

        output.each do |name, files|
          File.open(name, 'w') { |fh| fh.print template_for(files) }
        end

        output.collect(&:first)
      end

      private
      def template_for(files)
        <<-HTML
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type"/>
  <title>Jasmine Test Runner</title>
  <script type="text/javascript">
    window.console = { log: function(data) { 
      JHW.log(JSON.stringify(data));
    }, pp: function(data) {
      JHW.log(jasmine ? jasmine.pp(data) : JSON.stringify(data));
    } };
  </script>
  #{files.join("\n")}
</head>
<body>

<script type="text/javascript">
  jasmine.getEnv().addReporter(new jasmine.HeadlessReporter());
  jasmine.getEnv().execute();
</script>

</body>
</html>
HTML
      end
    end
  end
end

