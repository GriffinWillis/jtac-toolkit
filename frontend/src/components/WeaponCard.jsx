function WeaponCard({ weapon }) {
  const {
    name,
    description,
    variant,
    guidance_type,
    danger_close_contact,
    danger_close_airburst,
    weight,
    warhead_type,
    special_notes,
    targets,
    subtype_name
  } = weapon

  return (
    <div className="bg-dark-900 p-6 rounded-lg shadow-lg border border-dark-800 hover:border-dark-700 transition-colors">
      <div className="flex justify-between items-start mb-2">
        <h3 className="text-xl font-semibold text-gray-100">{name || 'Unknown'}</h3>
        {subtype_name && (
          <span className="px-3 py-1 bg-dark-700 text-gray-300 text-sm font-medium rounded">
            {subtype_name}
          </span>
        )}
      </div>

      {description && (
        <p className="text-gray-400 text-sm mb-4">{description}</p>
      )}

      <div className="grid grid-cols-2 gap-4 border-t border-dark-800 pt-4 mb-4">
        <div>
          <h4 className="text-sm font-medium text-gray-400 mb-2">Danger Close</h4>
          <div className="space-y-1">
            <div>
              <span className="text-gray-500 text-sm">Contact: </span>
              <span className="text-gray-200">{danger_close_contact}m</span>
            </div>
            <div>
              <span className="text-gray-500 text-sm">Airburst: </span>
              <span className="text-gray-200">
                {danger_close_airburst != null ? `${danger_close_airburst}m` : 'N/A'}
              </span>
            </div>
          </div>
        </div>

        <div>
          <h4 className="text-sm font-medium text-gray-400 mb-2">Warhead</h4>
          <div className="space-y-1">
            <div>
              <span className="text-gray-500 text-sm">Weight: </span>
              <span className="text-gray-200">
                {weight != null ? `${weight} lbs` : 'N/A'}
              </span>
            </div>
            <div>
              <span className="text-gray-500 text-sm">Type: </span>
              <span className="text-gray-200">{warhead_type || 'N/A'}</span>
            </div>
          </div>
        </div>
      </div>

      <div className="border-t border-dark-800 pt-4 mb-4">
        <h4 className="text-sm font-medium text-gray-400 mb-2">Guidance</h4>
        <p className="text-gray-200">{guidance_type || 'N/A'}</p>
      </div>

      {targets && targets.length > 0 && (
        <div className="border-t border-dark-800 pt-4 mb-4">
          <h4 className="text-sm font-medium text-gray-400 mb-2">Target Effectiveness</h4>
          <div className="flex flex-wrap gap-2">
            {targets.map((t, idx) => (
              <span
                key={idx}
                className="px-2 py-1 bg-dark-800 rounded text-sm"
              >
                <span className="text-gray-300">{t.target.name}</span>
                {t.effectiveness_rating && (
                  <span className={`ml-1 ${effectivenessColor(t.effectiveness_rating)}`}>
                    ({t.effectiveness_rating})
                  </span>
                )}
              </span>
            ))}
          </div>
        </div>
      )}

      {special_notes && (
        <div className="border-t border-dark-800 pt-4">
          <h4 className="text-sm font-medium text-gray-400 mb-2">Notes</h4>
          <p className="text-gray-300 text-sm">{special_notes}</p>
        </div>
      )}
    </div>
  )
}

export default WeaponCard
