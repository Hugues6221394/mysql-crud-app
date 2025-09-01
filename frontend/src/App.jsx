import { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

function App() {
  const [items, setItems] = useState([])
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [editingItem, setEditingItem] = useState(null)
  const [loading, setLoading] = useState(false)

  const API_BASE_URL = import.meta.env.VITE_API_URL || '/api'

  useEffect(() => {
    fetchItems()
  }, [])

  const fetchItems = async () => {
    try {
      setLoading(true)
      const response = await axios.get(`${API_BASE_URL}/items`)
      setItems(response.data)
    } catch (error) {
      console.error('Error fetching items:', error)
      alert('Failed to fetch items')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!name.trim()) return

    try {
      if (editingItem) {
        await axios.put(`${API_BASE_URL}/items/${editingItem.id}`, {
          name,
          description
        })
        setEditingItem(null)
      } else {
        await axios.post(`${API_BASE_URL}/items`, {
          name,
          description
        })
      }
      
      setName('')
      setDescription('')
      fetchItems()
    } catch (error) {
      console.error('Error saving item:', error)
      alert('Failed to save item')
    }
  }

  const handleEdit = (item) => {
    setEditingItem(item)
    setName(item.name)
    setDescription(item.description)
  }

  const handleDelete = async (id) => {
    if (!confirm('Are you sure you want to delete this item?')) return

    try {
      await axios.delete(`${API_BASE_URL}/items/${id}`)
      fetchItems()
    } catch (error) {
      console.error('Error deleting item:', error)
      alert('Failed to delete item')
    }
  }

  const cancelEdit = () => {
    setEditingItem(null)
    setName('')
    setDescription('')
  }

  return (
    <div className="container">
      <h1>MySQL CRUD Application</h1>
      
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Name:</label>
          <input
            type="text"
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </div>
        
        <div className="form-group">
          <label htmlFor="description">Description:</label>
          <textarea
            id="description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            rows="3"
          />
        </div>
        
        <button type="submit">
          {editingItem ? 'Update Item' : 'Add Item'}
        </button>
        
        {editingItem && (
          <button type="button" onClick={cancelEdit} style={{ marginLeft: '10px' }}>
            Cancel
          </button>
        )}
      </form>

      <div className="item-list">
        <h2>Items {loading && '(Loading...)'}</h2>
        
        {items.length === 0 && !loading ? (
          <p>No items found. Add some items to get started.</p>
        ) : (
          items.map((item) => (
            <div key={item.id} className="item">
              <h3>{item.name}</h3>
              <p>{item.description}</p>
              <div className="item-actions">
                <button onClick={() => handleEdit(item)}>Edit</button>
                <button onClick={() => handleDelete(item.id)}>Delete</button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  )
}

export default App
