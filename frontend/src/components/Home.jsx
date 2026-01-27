import { useState, useEffect } from 'react'
import FilterBar from './FilterBar'
import WeaponCard from './WeaponCard'

function Home() {
  const [weapons, setWeapons] = useState([])
  const [targets, setTargets] = useState([])
  const [guidanceTypes, setGuidanceTypes] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [filters, setFilters] = useState({
    weapon_type: '',
    guidance_type: '',
    target_id: ''
  })

  // Fetch targets for dropdown
  useEffect(() => {
    async function fetchTargets() {
      try {
        const response = await fetch('http://localhost:8000/api/targets')
        if (response.ok) {
          const data = await response.json()
          setTargets(data)
        }
      } catch (err) {
        console.error('Failed to fetch targets:', err)
      }
    }
    fetchTargets()
  }, [])

  // Fetch weapons with filters
  useEffect(() => {
    async function fetchWeapons() {
      setLoading(true)
      try {
        const params = new URLSearchParams()
        if (filters.weapon_type) params.append('weapon_type', filters.weapon_type)
        if (filters.guidance_type) params.append('guidance_type', filters.guidance_type)
        if (filters.target_id) params.append('target_id', filters.target_id)

        const url = `http://localhost:8000/api/weapons${params.toString() ? '?' + params.toString() : ''}`
        const response = await fetch(url)
        if (!response.ok) {
          throw new Error('Failed to fetch weapons')
        }
        const data = await response.json()
        setWeapons(data)

        // Extract unique guidance types from initial fetch (when no filters)
        if (!filters.weapon_type && !filters.guidance_type && !filters.target_id) {
          const uniqueGuidance = [...new Set(data.map(w => w.guidance_type).filter(Boolean))]
          setGuidanceTypes(uniqueGuidance.sort())
        }
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchWeapons()
  }, [filters])

  const handleFilterChange = (filterName, value) => {
    setFilters(prev => ({
      ...prev,
      [filterName]: value
    }))
  }

  return (
    <div>
      <h2 className="text-3xl font-bold mb-6">Weapon Catalog</h2>
      <FilterBar
        filters={filters}
        onFilterChange={handleFilterChange}
        targets={targets}
        guidanceTypes={guidanceTypes}
      />
      <div className="mt-8 grid grid-cols-1 gap-4">
        {loading && (
          <div className="text-center py-8 text-gray-400">Loading weapons...</div>
        )}
        {error && (
          <div className="text-center py-8 text-red-400">Error: {error}</div>
        )}
        {!loading && !error && weapons.length === 0 && (
          <div className="text-center py-8 text-gray-400">No weapons found</div>
        )}
        {!loading && !error && weapons.map(weapon => (
          <WeaponCard key={weapon.id} weapon={weapon} />
        ))}
      </div>
    </div>
  )
}

export default Home
