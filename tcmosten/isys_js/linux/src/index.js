import React from 'react'
import {render} from 'react-dom'
import axios from 'axios';
//import App from './App'
import { PlusCircle } from 'react-feather';



class AddButton extends React.Component{
  constructor(props) {
      super(props);
      this.state = {input: [{0: {Name: null}}]}; //key is string even without ""
      this.addInput = this.addInput.bind(this)
      this.removeInput = this.removeInput.bind(this)
      // This binding is necessary to make `this` work in the callback
    }    

    addInput(content){
      const form_array = this.state.input.slice()
      form_array.puch(content)
      this.setState((state)=>({input: form_array}))
    }
    removeInput(id){
      const form_array = this.state.input.slice()
      form_array.splice(id, 1);
      this.setState((state)=>({input: form_array}))
    }

    render() {
      console.log("ja2")
      return (
        <div>
          <MahnungForm addInput={this.addInput} removeInput={this.addInput} />
        </div>
      );
    }
}

class MahnungForm extends React.Component{
  constructor(props) {
      super(props);
      this.state = {formtable:{}} //wrapper MahnungTable
      this.handleAdd = this.handleAdd.bind(this);
      //this.handleDelete = this.handleDelete.bind(this);
      //this.removeTable = this.removeTable.bind(this)
    }    




    removeTable(id) {  
      console.log("removeTable")
      const target = {}
      const source = this.state.formtable
      var formtable_obj = Object.keys(source).length > 0 ? Object.assign(target, source) : {}
      delete formtable_obj[id]

      this.setState(
        (state)=>({formtable: formtable_obj})
      );
    }

    handleAdd() {
      const target = {}
      const source = this.state.formtable
      var formtable_obj = Object.keys(source).length > 0 ? Object.assign(target, source) : {}
      const formtable_length = Object.keys(formtable_obj).length
      const current_id = formtable_length > 0 ? parseInt(Object.keys(formtable_obj)[formtable_length-1])+1 : 1
      formtable_obj[current_id] = <MahnungTable key={current_id} id={current_id} removeTable={this.removeTable.bind(this)} />
      this.setState(
        (state)=>({formtable: formtable_obj})
      );
    }

    handleAction(){
      const action_signal = parseInt(Object.keys(this.props.action_signal)[0]) //if > 0 is add <0 is remove
      console.log("action_signal " + action_signal)
      const max_index = (this.state.length) > 0 ? parseInt(Object.keys(this.state[this.state.length-1])[0]) : 0
      console.log("max_index " + max_index)
      var tables = (this.state.formtables.length) > 0 ? this.state.formtables.slice() : []
      console.log("s1")
      if (action_signal > max_index) {
        console.log("s2")
        tables.push(<MahnungTable key={action_signal} getKey={this.props.getKey} />)
        console.log("s3")
        this.setState(
          (state)=>({formtables:tables})
        );
        console.log("s4")
        console.log("deleteIdx2 " + this.props.deleteIdx)
        console.log(this.state.formtables)
      } else if (action_signal == max_index && max_index > 0){
          const index = this.props.deleteIdx
          if (index != -1){
            tables.splice(index, 1);
            this.setState(
              (state)=>({formtables:tables})
            );
          }
          
      }
    } 

    render() {

      //problem
      return (
        <fragment>
          <button onClick={this.handleAdd}>
            {Object.keys(this.state.formtable).length}
          </button>
          <table>
            <tr>
              <th>Pos</th>
              <th>Content</th>
            </tr>
          </table>
          <form>
          <ul>
            {Object.values(this.state.formtable)}
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
      this.handleClick = this.handleClick.bind(this)
    }    

    handleClick(){
      console.log("handleClick " + this.props.id);
      this.props.removeTable(this.props.id)
      console.log("handleClick " + "done");
    }

    render() {
      console.log("s5")
      return (
        <li>
          <label>
            Name:
            <input type="text" name="name" />
          </label>
          <button type="button" key={this.props.id} onClick={this.handleClick}>
            löschen
          </button>
        </li>

      );

    }
}
render(<AddButton />,document.getElementById('root'))