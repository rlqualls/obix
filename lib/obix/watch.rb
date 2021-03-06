module OBIX
  
  class Watch

    # Initialize a watch.
    #
    # watch - An OBIX object that implements the Watch contract.
    def initialize watch
      @watch = watch
    end

    # Reference the watch.
    #
    # Returns a String describing the URL to the watch.
    def url
      @watch.href
    end

    # Reference the lease of the watch.
    #
    # Returns an Integer describing the lease in seconds.
    def lease
      @watch.objects.find { |o| o.name == "lease" }.val
    end

    # Add objects to the watch.
    #
    # list - An Array of String instances describing objects to add to the watch.
    def add list
      add = @watch.objects.find { |obj| obj.name == "add" }

      obix = OBIX::Builder.new do |obix|
        obix.obj is: "obix:WatchIn" do |obix|
          obix.list name: "hrefs" do |obix|
            list.each do |item|
              obix.uri val: item
            end
          end
        end
      end

      add.invoke obix.object
    end

    # Remove objects from the watch.
    #
    # list - An Array of String instances describing objects to remove from the watch.
    def remove list
      remove = @watch.objects.find { |obj| obj.name == "remove" }

      obix = OBIX::Builder.new do |obix|
        obix.obj is: "obix:WatchIn" do |obix|
          obix.list name: "hrefs" do |obix|
            list.each do |item|
              obix.uri val: item
            end
          end
        end
      end

      remove.invoke obix.object
    end

    # Poll objects that have changed
    def changes
      poll = @watch.objects.find { |obj| obj.name == "pollChanges" }

      poll.invoke.objects.find do |object|
        object.name == "values"
      end.objects
    end

    # Poll all objects
    def all
      poll = @watch.objects.find { |obj| obj.name == "pollRefresh" }

      poll.invoke.objects.find do |object|
        object.name == "values"
      end.objects
    end

    # Delete the watch.
    def delete
      @watch.objects.find do |object|
        object.name == "delete"
      end.invoke
    end

    def to_s
      @watch.to_s
    end

    class << self
      alias make new

      # Create a new watch.
      #
      # source - A Hash of options (see OBIX#parse for details).
      def make source
        service = OBIX.parse source

        make = service.objects.find do |object|
          object.name == "make"
        end

        new make.invoke
      end

      # Connect to an existing watch.
      #
      # source - A Hash of options (see OBIX#parse for details).
      def connect source
        new OBIX.parse source
      end
    end

  end

end
