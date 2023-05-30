class <%= plural_table_name.classify %> < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[<%=
      attributes.map { |e|
        if e.reference?
          e.name + '_id'
        else
          e.name
        end
      }.concat(["id", "created_at", "updated_at"]).join(" ")
    %>]
  end
<% attributes.reject(&:password_digest?).each do |attribute| -%>
<% if attribute.reference? -%>
  <%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% end -%>
end
