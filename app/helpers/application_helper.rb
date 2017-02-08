module ApplicationHelper
  def profile_img(user)
    return image_tag(user.avatar, alt: user.name) if user.avatar?

    unless user.provider.blank?
      img_url = user.image_url
    else
      if user.id==current_user.id
        img_url = "no_image.png"
      else
        img_url = "#{(user.id%24)+1}.png"
      end
    end
    image_tag(img_url, alt: user.name)
  end

  def profile_img_thumb(user)
    return image_tag(user.avatar.thumb, alt: user.name) if user.avatar?

    unless user.provider.blank?
      img_url = user.image_url
    else
      if user.id==current_user.id
        img_url = "no_image.png"
      else
        img_url = "#{(user.id%24)+1}.png"
      end
    end
    image_tag(img_url, alt: user.name)
  end

  def profile_img_lgthumb(user)
    return image_tag(user.avatar.lgthumb, alt: user.name) if user.avatar?

    unless user.provider.blank?
      img_url = user.image_url
    else
      if user.id==current_user.id
        img_url = "no_image.png"
      else
        img_url = "#{(user.id%24)+1}.png"
      end
    end
    image_tag(img_url, alt: user.name)
  end
end

module ActionView
  module Helpers
    module FormHelper
      def error_messages!(object_name, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if !resource || resource.errors.empty?

        messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

        html = <<-HTML
          <div class="alert alert-danger">
            <ul>#{messages}</ul>
          </div>
        HTML

        html.html_safe
      end

      def error_css(object_name, method, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if resource.errors.empty?

        resource.errors.include?(method) ? 'has-error' : ''
      end
    end

    class FormBuilder
      def error_messages!(options = {})
        @template.error_messages!(@object_name, options.merge(object: @object))
      end

      def error_css(method, options = {})
        @template.error_css(@object_name, method, options.merge(object: @object))
      end
    end
  end
end
