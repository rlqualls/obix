module OBIX
  module Objects

    class Base
      extend Tag

      attr_reader :objects, :attributes

      def initialize attributes = {}, objects = [], &block
        @attributes = attributes

        if block_given?
          builder = OBIX::Builder.new &block

          @objects = builder.objects
        else
          @objects = objects
        end
      end

      def to_xml
        xml = Nokogiri::XML::Builder.new do |xml|
          xml.send tag, attributes do
            objects.each do |object|
              xml.send object.tag, object.attributes
            end
          end
        end

        xml.doc.root.to_xml
      end

      def to_s
        attributes = @attributes.map do |key, value|
          "#{key}: \"#{value}\""
        end.join " "

        "#<#{self.class} #{attributes}>"
      end

      class << self

        # Initialize an object with the given string.
        #
        # object - A Nokogiri::XML::Node describing an element.
        #
        # Returns an Object instance.
        def parse element
          object = OBIX::Objects.list.find do |object|
            object.new.tag.to_s == element.name
          end

          raise "Unknown element #{element}" unless object

          attributes = {}
          objects    = []

          element.attributes.each do |name, attribute|
            attributes.store name, attribute.value
          end

          element.children.each do |child|
            next if child.is_a? Nokogiri::XML::Text

            objects.push parse child
          end

          object.new attributes, objects
        end

        # Register objects for classes that inherit from this class.
        def inherited object
          OBIX::Objects.register object
        end

      end

    end

  end
end
