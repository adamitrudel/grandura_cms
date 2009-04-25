module NavigationTags
  include Radiant::Taggable
  include ActionView::Helpers::TagHelper
  
  class NavTagError < StandardError; end
  
  desc %{Render a navigation menu. Walks down the directory tree, expanding the tree up to the current page.

    *Usage:*
    <pre><code><r:nav [id="subnav"] [root=\"/products\"] [include_root=\"true\"] [depth=\"2\"] [expand_all=\"true\"]/></code></pre> 
    *Attributes:*
    
    root: defaults to "/", where to start building the navigation from, you can i.e. use "/products" to build a subnav
    include_root: defaults to false, set to true to include the root page (i.e. Home)
    ids_for_lis: defaults to false, enable this to give each li an id (it's slug prefixed with nav_)
    ids_for_links: defaults to false, enable this to give each link an id (it's slug prefixed with nav_)
    
    depth: defaults to 1, which means no sub-ul's, set to 2 or more for a nested list
    expand_all: defaults to false, enable this to have all li's create sub-ul's of their children, i.o. only the currently active li
    id, class,..: go as html attributes of the outer ul
  }
    
  tag "nav" do |tag|
    root_url = tag.attr.delete('root')
    if root_url =~ /level-(\d+)/
      level = $1.to_i
      root = tag.locals.page
      while (root.url.count("/") != level && root.parent)
        root = root.parent
      end
    else
      root = Page.find_by_url(root_url || "/")
      raise NavTagError, "No page found at \"#{root_url}\" to build navigation from." if root.class_name.eql?('FileNotFoundPage')
    end
    
    depth = tag.attr.delete('depth') || 1
    ['include_root', 'ids_for_lis', 'ids_for_links', 'expand_all', 'first_set'].each do |prop|
      eval "@#{prop} = tag.attr.delete('#{prop}') || false"
    end
    
    if @include_root
      css_class = [("current" if tag.locals.page == root), "first"].compact
      @first_set = true
      url = (defined?(SiteLanguage)  && SiteLanguage.count > 0) ? "/#{Locale.language.code}#{root.url}" : root.url
      tree = %{<li#{" class=\"#{css_class.join(" ")}\"" unless css_class.empty?}#{" id=\"" +
        (root.slug == "/" ? 'home' : root.slug) + "\"" if @ids_for_lis}><a href="#{url}"#{" id=\"link_" + (root.slug == "/" ? 'home' : root.slug) + "\"" if @ids_for_links}>#{escape_once(root.breadcrumb)}</a></li>\n}
    else
      tree = ""
    end
    
    for child in root.children
      tree << tag.render('sub-nav', {:page => child, :depth => depth.to_i - 1 })
    end
    
    if tag.attr
      html_options = tag.attr.stringify_keys
      tag_options = tag_options(html_options)
    else
      tag_options = nil
    end
    
    %{<ul#{tag_options} class="depth-1">
    #{tree}
    </ul>}

  end
  
  tag "sub-nav" do |tag|
    current_page = tag.locals.page
    child_page = tag.attr[:page]
    depth = tag.attr[:depth]
    return if child_page.part("no-map") or child_page.virtual? or !child_page.published? or child_page.class_name.eql? "FileNotFoundPage"
    css_class = [("current" if current_page == child_page), ("has_children" if child_page.children.size > 0), ("parent_of_current" if current_page.url.starts_with?(child_page.url) and current_page != child_page)].compact
    if !@first_set
      css_class << 'first'
      @first_set = true
    end
    url = (defined?(SiteLanguage)  && SiteLanguage.count > 0) ? "/#{Locale.language.code}#{child_page.url}" : child_page.url
    r = %{\t<li#{" class=\"#{css_class.join(" ")}\"" unless css_class.empty?}#{" id=\"nav_" + child_page.slug + "\"" if @ids_for_lis}>
    <a href="#{url}"#{" id=\"link_" + (child_page.slug == "/" ? 'home' : child_page.slug) + "\"" if @ids_for_links}>#{child_page.breadcrumb}</a>}
    published_children = child_page.children.delete_if{|c| c.part("no-map") || !c.published? }
    if published_children.size > 0 and depth.to_i > 0 and 
        child_page.class_name != 'ArchivePage' and 
        (@expand_all || current_page.url.starts_with?(child_page.url) )
      r << "<ul class=\"depth-#{depth}\">\n"
      child_page.children.each do |child|
        r << tag.render('sub-nav', :page => child, :depth => depth.to_i - 1 )
      end
      r << "</ul>\n"
    end
    r << "</li>\n"
  end
  
  
  # Inspired by this thread: 
  # http://www.mail-archive.com/radiant@lists.radiantcms.org/msg03234.html
  # Author: Marty Haught
  desc %{
    Renders the contained element if the current item is an ancestor of the current page or if it is the page itself. 
  }
  tag "if_ancestor_or_self" do |tag|
    Page.benchmark "TAG: if_ancestor_or_self - #{tag.locals.page.url}" do
      tag.expand if tag.globals.actual_page.url.starts_with?(tag.locals.page.url)
    end
  end
  
  desc %{
    Renders the contained element if the current item is also the current page. 
  }
  tag "if_self" do |tag|
    Page.benchmark "TAG: if_self - #{tag.locals.page.url}" do
      tag.expand if tag.locals.page == tag.globals.page
    end
  end
  
  desc %{    
    Renders the contained elements only if the current contextual page has children.
    
    *Usage:*
    <pre><code><r:if_children>...</r:if_children></code></pre>
  }
  tag "if_children" do |tag|
    Page.benchmark "TAG: if_children - #{tag.locals.page.url}" do
      tag.expand if tag.locals.page.children.size > 0
    end
  end
  
  tag "unless_children" do |tag|
    tag.expand unless tag.locals.page.children.size > 0
  end
  
  tag "benchmark" do |tag|
    Page.benchmark "BENCHMARK: #{tag.attr['name']}"do
      tag.expand
    end
  end
  
end