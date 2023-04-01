class <%= plural_table_name.classify %> < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    <%=
      attributes.map { |e|
        if e.reference?
          e.name + '_id'
        else
          e.name
        end
      }.to_s
    %>
  end

<% attributes.reject(&:password_digest?).each do |attribute| -%>
<% if attribute.reference? -%>
  <%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% end -%>
end

