class Invoice < ApplicationRecord

  def destroy_association
    if items.count == 1
      destroy
    else
      false
    end
  end
end
