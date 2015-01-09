class ResourceRegistration < ActiveRecord::Base
  has_many :typed_links, dependent: :destroy, inverse_of: :resource_registration

  validates :typed_links,
    presence: true

  validates :ep,
    presence: true,
    uniqueness: true,
    exclusion: { in: %w(::1) }

  validates :lt,
    inclusion: { in: 60..4294967295 }

  validate :bytesizes

  def self.default_con(request)
    dtls = request.env['coap.dtls']

    scheme = 'coap'
    scheme = 'coaps' if !dtls.nil? && dtls != 'NoSec'

    ip = request.ip
    ip = "[#{ip}]" if IPAddr.new(ip).ipv6?

    "#{scheme}://#{ip}"
  end

  private

  def bytesizes
    if ep.present? && ep.bytesize > 63
      errors.add(:ep, 'ep size > 63')
    end

    [:d, :et].each do |attr|
      if send(attr).present? && send(attr).bytesize >= 63
        errors.add(attr, "#{attr} size >= 63")
      end
    end
  end
end
