module DealerLocation::Tags
  include Radiant::Taggable
  include ActionView::Helpers::TagHelper
  
  def _product_available_html(x)
    x ? '<div class="selSquare"></div>' : ''
  end
    
  def _dealers_html(dealers)
    
    if dealers.blank?
      return "There is no dealer in this location."
    end
    
    r = %{
        <tr>
          <td style="background-color:#92cdda;height:32px;padding-top:3px;"><p>Company</p></td>
          <td style="background-color:#92cdda;height:32px;padding-top:3px;"><p>Address</p></td>
          <td width="75" style="background-color:#92cdda;height:32px;padding-top:3px;"><p>Windows</p></td>
          <td width="75" style="background-color:#92cdda;height:32px;padding-top:3px;"><p>Siding</p></td>
        </tr>
    }
    
    
    r << dealers.map { |dealer|
    %{
        <tr>
           <td style="background-color:#d9f1f5;height:32px;padding-top:3px;">
            <p>
              <strong>#{dealer.company}</strong><br />
              #{dealer.contact_person}
            </p>
          </td>
          <td style="background-color:#d9f1f5;height:32px;padding-top:3px;">
            <p>
              <strong>#{dealer.phone}</strong><br />
              #{dealer.address}
            </p>
          </td>
          <td style="background-color:#d9f1f5;height:32px;">
            #{_product_available_html(dealer.windows)}
          </td>
          <td style="background-color:#d9f1f5;height:32px;">
            #{_product_available_html(dealer.siding)}
          </td>
        </tr>
    }}.join
  end
  
  desc %{    
    *Usage*:
    <pre><code><r:dealer_location /></code></pre>
  }
  tag 'dealer_location' do |tag|
    r = %{
      <div id="content_contact">
      <table width="100%" border="0" cellspacing="3" cellpadding="0">
    }
    
    r << Location.all.map{ |location|
      dealers = Dealer.find(:all, :conditions => { :location_id => location.id })
      dealers.blank? ? "" : %{
          <tr>
            <td colspan="4"><h2 class="citytxt">#{location.name}</h2></td>
          </tr>
          #{_dealers_html(dealers)}
          <tr><br /></tr>
      }
    }.join
    
    r << %{
      </table>
      </div>
    }
  end
end