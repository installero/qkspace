module ApplicationHelper
  def current_user_owns_project?
    return false unless user_signed_in?

    current_user.owns?(@project)
  end

  def title
    key = "#{params[:controller].underscore.gsub('/', '.')}.#{params[:action]}"
    case key
    when "private.projects.show", "public.projects.show"
      @project.title
    when "private.pages.show", "public.pages.show"
      @page.title
    else
      t "#{key}.title"
    end
  end

  def or_back_link
    t('views.or_back_link', href: link_to(t('views.back'), :back)).html_safe
  end

  def markdown_hint_link
    href = link_to t('views.markdown.hint_a'), '#', data: {
      component: 'modal',
      target: '#markdown-modal-window'
    }
    t('views.markdown.hint_link', href: href).html_safe
  end

  def markdown_hint
    t('views.markdown.hint_link', href: t('views.markdown.hint_a'))
  end

  def markdown_partial
    render partial: 'shared/md_help'
  end

  def private_domain
    request.env["qkspace.area"][:private_domain]
  end

  def link_to_switch_locale
    current_locale_index = I18n.available_locales.find_index(I18n.locale)
    next_locale = I18n.available_locales[(current_locale_index + 1) % I18n.available_locales.length]

    country_code = next_locale.to_s.split('-').last.downcase # en-US -> us
    country_code = 'us' if country_code == 'en' # we don't have EN flag for now

    link_to %{<span class="flag-icon flag-icon-#{country_code}"></span>}.html_safe,
      {locale: next_locale},
      title: t('views.switch_locale')
  end
end
