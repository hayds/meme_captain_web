class SrcSet < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true
  validates :name, uniqueness: true

  has_and_belongs_to_many :src_images
  belongs_to :user

  def add_src_images(add_id_hashes)
    to_add = SrcImage.find_all_by_id_hash(add_id_hashes) - self.src_images

    unless to_add.empty?
      self.src_images.concat(to_add)
      self.touch
    end
  end

  def delete_src_images(delete_id_hashes)
    to_delete = SrcImage.find_all_by_id_hash(delete_id_hashes)

    unless to_delete.empty?
      self.src_images.delete(*to_delete)
      self.touch
    end
  end

  def thumbnail
    recent = src_images.active.most_recent
    recent.first.src_thumb unless recent.empty?
  end

  def thumb_width
    thumb = thumbnail
    thumb.width if thumb
  end

  def thumb_height
    thumb = thumbnail
    thumb.height if thumb
  end

  def by
    try(:user).try(:email)
  end

  scope :active, where(:is_deleted => false)

  scope :owned_by, lambda { |user| where(:user_id => user.id) }

  scope :most_recent, lambda { |limit=1| order(:updated_at).reverse_order.limit(limit) }
end
