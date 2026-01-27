import { useState, useEffect } from 'react'
import FilterBar from './FilterBar'
import WeaponCard from './WeaponCard'

function Home() {
  const [weapons, setWeapons] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    async function fetchWeapons() {
      try {
        const response = await fetch('http://localhost:8000/api/weapons')
        if (!response.ok) {
          throw new Error('Failed to fetch weapons')
        }
        const data = await response.json()
        setWeapons(data)
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchWeapons()
  }, [])

  return (
    <div>
      <h2 className="text-3xl font-bold mb-6">Weapon Catalog</h2>
      <FilterBar />
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
