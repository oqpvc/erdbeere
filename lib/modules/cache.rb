module CacheIt
  def self.included(base)
    base.extend TheActualCache
  end
  module TheActualCache
    def cache_it(method)
      old_method = instance_method(method)
      define_method(method) do
        # this is a hotfix to cache a result without interference from globalize
        ck = cache_key.split('/')[0..1].join('/')
        Rails.cache.fetch("#{ck}/#{method}") do
          old_method.bind(self).()
        end
      end
    end
  end
end
