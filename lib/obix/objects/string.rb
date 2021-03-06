module OBIX
  module Objects

    # Strings represent strings of characters.
    class String < Object
      tag :str

      attribute :val, type: Types::String, default: ""
      attribute :min, type: Types::Integer
      attribute :max, type: Types::Integer
    end

  end
end
