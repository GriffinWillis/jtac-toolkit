import FilterBar from './FilterBar'
import WeaponCard from './WeaponCard'

function Home() {
  return (
    <div>
      <h2 className="text-3xl font-bold mb-6">Weapon Catalog</h2>
      <FilterBar />
      <div className="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <WeaponCard />
        <WeaponCard />
        <WeaponCard />
      </div>
    </div>
  )
}

export default Home