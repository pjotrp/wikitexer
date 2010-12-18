
class References < Hash

  def has? key
    self[key] != nil and self[key].strip != ''
  end

end

