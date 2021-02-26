import React from 'react'
import {render} from 'react-dom'
import axios from 'axios';
//import App from './App'
import { PlusCircle } from 'react-feather';



class AddButton extends React.Component{
  constructor(props) {
      super(props);
      this.state = {count:1};
  
      // This binding is necessary to make `this` work in the callback
      this.handleClick = this.handleClick.bind(this);
    }    

    handleClick() {
      this.setState(
         (state)=>({count: state.count+1})
      );
    }

    render() {
      console.log("ja2")
      return (
        <div>
          <button onClick={this.handleClick}>
          {this.state.count}
          </button>

          <MahnungForm rows={this.state.count}></MahnungForm>
        </div>
      );

    }
}

class MahnungForm extends React.Component{
  constructor(props) {
      super(props);
    }    



    render() {
      console.log("ja")
      var tblen = []
      for (var i=0;i<this.props.rows;i++){
        tblen.push(i)
      }
      var items = tblen.map((pos)=><MahnungTable key={pos.toString()} />);
      console.log("ja1")
      return (
        <fragment>
          <table>
            <tr>
              <th>Pos</th>
              <th>Content</th>
            </tr>
          </table>

          {items} 
        </fragment>



      );

    }
}

class MahnungTable extends React.Component{
  constructor(props) {
      super(props);
    }    


    render() {
      return (
        <form>
          <label>
            Name:
            <input type="text" name="name" />
          </label>
          <input type="submit" value="Submit" />
        </form>
      );

    }
}
render(<AddButton />,document.getElementById('root'))