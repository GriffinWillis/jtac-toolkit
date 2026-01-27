function WeaponCard({ weapon }) {
  const { designation, weapon_type, danger_close_contact, danger_close_airburst, guidance_types } = weapon

  return (
    <div className="bg-dark-900 p-6 rounded-lg shadow-lg border border-dark-800 hover:border-dark-700 transition-colors">
      <div className="flex justify-between items-start mb-4">
        <h3 className="text-xl font-semibold text-gray-100">{designation || 'Unknown'}</h3>
        {weapon_type && (
          <span className="px-3 py-1 bg-dark-700 text-gray-300 text-sm font-medium rounded">
            {weapon_type}
          </span>
        )}
      </div>

      <div className="border-t border-dark-800 pt-4 mb-4">
        <h4 className="text-sm font-medium text-gray-400 mb-2">Danger Close</h4>
        <div className="flex gap-8">
          <div>
            <span className="text-gray-500 text-sm">Contact: </span>
            <span className="text-gray-200">
              {danger_close_contact != null ? `${danger_close_contact}m` : 'N/A'}
            </span>
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
        <h4 className="text-sm font-medium text-gray-400 mb-2">Guidance</h4>
        <p className="text-gray-200">
          {guidance_types && guidance_types.length > 0
            ? guidance_types.map(g => g.name).join(', ')
            : 'N/A'}
        </p>
      </div>
    </div>
  )
}

export default WeaponCard
