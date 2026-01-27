function FilterBar({ filters, onFilterChange, targets, guidanceTypes }) {
  const weaponTypes = ['BOMB', 'MISSILE', 'ROCKET', 'GUN']

  return (
    <div className="bg-dark-900 p-4 rounded-lg shadow-md border border-dark-800">
      <div className="flex flex-wrap gap-4">
        <div className="flex flex-col">
          <label className="text-sm text-gray-400 mb-1">Weapon Type</label>
          <select
            value={filters.weapon_type}
            onChange={(e) => onFilterChange('weapon_type', e.target.value)}
            className="bg-dark-800 border border-dark-700 text-gray-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-accent"
          >
            <option value="">All</option>
            {weaponTypes.map(type => (
              <option key={type} value={type}>{type}</option>
            ))}
          </select>
        </div>

        <div className="flex flex-col">
          <label className="text-sm text-gray-400 mb-1">Guidance Type</label>
          <select
            value={filters.guidance_type}
            onChange={(e) => onFilterChange('guidance_type', e.target.value)}
            className="bg-dark-800 border border-dark-700 text-gray-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-accent"
          >
            <option value="">All</option>
            {guidanceTypes.map(type => (
              <option key={type} value={type}>{type}</option>
            ))}
          </select>
        </div>

        <div className="flex flex-col">
          <label className="text-sm text-gray-400 mb-1">Target</label>
          <select
            value={filters.target_id}
            onChange={(e) => onFilterChange('target_id', e.target.value)}
            className="bg-dark-800 border border-dark-700 text-gray-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-accent"
          >
            <option value="">All</option>
            {targets.map(target => (
              <option key={target.id} value={target.id}>{target.name}</option>
            ))}
          </select>
        </div>
      </div>
    </div>
  )
}

export default FilterBar
