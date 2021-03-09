import React from 'react'
import {render} from 'react-dom'
import axios from 'axios';
//import App from './App'
import { PlusCircle } from 'react-feather';



class AddButton extends React.Component{
  constructor(props) {
      super(props);
      this.state = {0: {Name: ""}}; //key is string even without ""
      this.addInput = this.addInput.bind(this)
      this.removeInput = this.removeInput.bind(this)
      this.setInput = this.setInput.bind(this)
      // This binding is necessary to make `this` work in the callback
    }    

    addInput(content){

      const input_length = Object.keys(this.state).length
      const current_id = parseInt(Object.keys(this.state)[input_length-1])+1 
  
      this.setState({[current_id]: {Name: ""}}) //perform a shadown merge

    }
    removeInput(id){

      var input_obj = {...this.state}
      delete input_obj[id]

      this.setState({input_obj})
    }
    
    setInput(id,value){
      console.log("setInput top")
      console.log("setInput value " + value)
      this.setState({[id]: {Name: value}}) //perform a shadown merge, update will be delayed. this.state is updated after this setInput function is finished. 


    }

    render() {
      console.log("ja2")
      console.log(this.state)
      return (
        <div>
          <MahnungForm addInput={this.addInput} removeInput={this.addInput} setInput={this.setInput} />
        </div>
      );
    }
}

class MahnungForm extends React.Component{
  constructor(props) {
      super(props);
      this.state = {0: undefined} //wrapper MahnungTable
      this.handleAdd = this.handleAdd.bind(this);
      this.setInput = this.setInput.bind(this);
      //this.removeTable = this.removeTable.bind(this)
    }    


    setInput(id,value){
      console.log("setInput middle")
      this.props.setInput(id,value)
    }

    removeTable(id) {  
      console.log("removeTable")

      var formtable_obj = {...this.state}
      delete formtable_obj[id]
      
      this.props.removeInput(id)
      this.setState({formtable_obj})
    }

    handleAdd() {

      const formtable_length = Object.keys(this.state).length
      const current_id = parseInt(Object.keys(this.state)[formtable_length-1])+1

      this.props.addInput()
      this.setState({[current_id]: <MahnungTable key={current_id} id={current_id} removeTable={this.removeTable.bind(this)} setInput={this.setInput} />})
    }

    handleSubmit(){
      
    }

    render() {

      //problem
      return (
        <fragment>
          <button onClick={this.handleAdd}>
            {Object.keys(this.state).length}
          </button>
          <table>
            <tr>
              <th>Pos</th>
              <th>Content</th>
            </tr>
          </table>
          <form onSubmit={this.handleSubmit}>
          <ul>
            {Object.values(this.state)}
          </ul>
          <input type="submit" value="Submit" />
          </form>
        </fragment>
      );
    }
}

class MahnungTable extends React.Component{
  constructor(props) {
      super(props);
      this.state={name: ""}
      this.handleClick = this.handleClick.bind(this)
      this.handleChange = this.handleChange.bind(this)
    }    

    handleClick(){
      console.log("handleClick " + this.props.id);
      this.props.removeTable(this.props.id)
      console.log("handleClick " + "done");
    }

    handleChange(event){
      console.log("handleChange id" + this.props.id);
      console.log("handleChange name" + event.target.name);
      console.log("handleChange value" + event.target.value);
      this.props.setInput(this.props.id, event.target.value)
      this.setState({[event.target.name]: event.target.value})
      console.log("handleChange " + "done");     
    }

    render() {
      console.log("s5")
      return (
        <li>
          <label>
            Name:
            <input type="text" name="name" value={this.state.name} onChange={this.handleChange} />
          </label>
          <button type="button" key={this.props.id} onClick={this.handleClick}>
            löschen
          </button>
        </li>
      );
    }
}
render(<AddButton />,document.getElementById('root'))