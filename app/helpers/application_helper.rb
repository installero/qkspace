module ApplicationHelper
  def current_user_collaborates_project?
    current_user&.collaborates?(@project)
  end

  def current_user_owns_project?
    current_user&.owns?(@project)
  end

  def show_header?
    signed_in? && (private_controller? || current_user_collaborates_project?)
  end

  def title
    key = "#{params[:controller].underscore.gsub('/', '.')}.#{params[:action]}"
    case key
    when "private.projects.show", "public.projects.show"
      @project.title
    when "private.pages.show", "public.pages.show"
      @page.title
    when "private.project_collaborations.index", "private.project_collaborations.create"
      t "#{key}.title", project_title: @project.title
    else
      t "#{key}.title"
    end
  end

  def or_back_link
    t('views.or_back_link', href: link_to(t('views.back'), :back)).html_safe
  end

  def link_to_switch_locale
    current_locale_index = I18n.available_locales.find_index(I18n.locale)
    next_locale = I18n.available_locales[(current_locale_index + 1) % I18n.available_locales.length]

    country_code = next_locale.to_s.split('-').last.downcase # en-US -> us
    country_code = 'us' if country_code == 'en' # we don't have EN flag for now

    link_to %{<span class="flag-icon flag-icon-#{country_code}"></span>}.html_safe,
      {locale: next_locale},
      title: t('views.switch_locale', locale: next_locale)
  end

  def sign_up_link
    link_to t("devise.shared_links.sign_up"), new_user_registration_path
  end

  def sign_in_link
    link_to t("devise.shared_links.sign_in"), new_user_session_path
  end

  def forgot_password_link
    link_to t("devise.shared_links.forgot_your_password"), new_user_password_path
  end
end
