class Object
  def send_chain(arr)
    arr.inject(self) { |o, a| o.send(a) }
  end
end
